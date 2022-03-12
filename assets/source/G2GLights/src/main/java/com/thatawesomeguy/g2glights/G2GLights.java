package com.thatawesomeguy.g2glights;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

import javax.imageio.ImageIO;
import javax.swing.*;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.io.PrintStream;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;

/*
Main communication is via stdin and stdout.
Emulicious sends commands to the process via stdout and expects replies on stdin.
A command is a single character followed by its arguments.
w indicates that the rom writes to a specific port
r indicates that the rom reads from a specific port

Commands and on a newline character. This yields better readability for debugging but can also help you indentify the end of a command (should not be necessary because each command has a fixed size).
A read command expects a 2-character hex number as reply. That's the byte to be read by the rom.
A write command expects an arbitrary 1-character reply as ACK. That's for synchronization purposes. This way you cannot get another write command before you're done with the current one.
Both commands have a timestamp specified in cycles. This allows for accurate timings of signals.
So a read is 'r' followed by port followed by 4-byte (i.e. 8-character hex number) specifying the current cycle counter.
A write is 'w' followed by port followed by 1-byte (i.e. 2-character hex number, which is the byte that was written) followed by 4-byte cycle counter.
On stderr you can send the exact string "NMI" to assert an nmi interrupt. You can also use stderr for debugging because Emulicious forwards everything it receives on stderr to its own stderr.


Example commands:
Emulicious stdout -> r200000004\n  // read port 2 at cycle count 4
Plugin stdout -> FF
Emulicious stdout -> w3ff00000008\n // write value $ff to port 3 at cycle count 8
Plugin stdout -> 0
Plugin stderr -> NMI
Emulicious asserts NMI interrupt on Game Gear
 */

public class G2GLights extends Canvas {
    private BufferedImage backgroundimg = null;
    private int _clock = 0;
    private int _latch = 0;
    private int[] _register = new int[5];
    private int[] _output = new int[40];
    private List<List<LightObject>> _channel = new ArrayList<List<LightObject>>(40);

    public static void main(String[] args) throws Exception {
        JFrame frame = new JFrame("Christmas Lights");
        G2GLights canvas = new G2GLights();
        canvas.setSize(960, 540);
        frame.add(canvas);
        frame.pack();
        frame.setResizable(false);
        frame.addWindowListener(new java.awt.event.WindowAdapter() {
            @Override
            public void windowClosing(java.awt.event.WindowEvent windowEvent) {
                System.exit(0);
            }
        });
        frame.setVisible(true);

        System.err.println("Starting interface:");
        System.setOut(new PrintStream(System.out, true));
        while (true) {
            int controlPort = 0;
            int value = 0;
            int cyclecount = 0;
            byte[] data = new byte[8];

            int command = System.in.read();

            if (command == -1)
                break;
            switch (command) {
                case 'r':
                    controlPort = Character.getNumericValue((char) System.in.read());
                    System.in.read(data, 0, 8);
                    cyclecount = Integer.parseInt(new String(data, 0, 8, StandardCharsets.UTF_8), 16);
                    break;

                case 'w':
                    controlPort = Character.getNumericValue(System.in.read());
                    System.in.read(data, 0, 2);
                    value = Integer.parseInt(new String(data, 0, 2, StandardCharsets.UTF_8), 16);
                    System.in.read(data, 0, 8);
                    cyclecount = Integer.parseInt(new String(data, 0, 8, StandardCharsets.UTF_8), 16);

                    if (controlPort == 1) {
                        canvas.WriteIO(value);
                    }

                    System.out.print("0"); // Acknowledge read
                    break;

                case '\n':
                case '\r':
                    break;

                default:
                    System.err.print("Unknown command received " + command + " ");
                    System.exit(1);
            }
        }
    }

    public G2GLights() {
        // Create an array of 40 output channels for the lights
        for (int i = 0; i < 40; i++) {
            List channel = new ArrayList<LightObject>();
            _channel.add(channel);
        }

        File[] directories = new File("./G2GLights/").listFiles(File::isDirectory);
        if (directories == null) {
            System.err.print("G2GLights directory is missing!\n");
        } else {
            JSONParser parser = new JSONParser();

            try {
                Object obj = parser.parse(new FileReader(directories[0] + "/layout.json"));

                JSONObject jsonObject = (JSONObject) obj;
                String sceneName = (String) jsonObject.get("name");
                System.err.print(sceneName + "\n");

            } catch (Exception e) {
                e.printStackTrace();
            }

            try {
                backgroundimg = ImageIO.read(new File("background.png"));
            } catch (IOException e) {
                e.printStackTrace();
            }

            LightObject lo = new LightObject();
            lo.x = 20;
            lo.y = 20;
            try {
                lo.image = ImageIO.read(new File("light.png"));
            } catch (IOException e) {
                e.printStackTrace();
            }
            _channel.get(0).add(lo);
        }
    }

    @Override
    public void paint(Graphics g) {
        Graphics2D g2 = (Graphics2D) g;

        if (backgroundimg != null) {
            g2.drawImage(backgroundimg, 0, 0, getWidth(), getHeight(), null);
        }

        for (int i = 0; i < 40; i++) {
            if (_output[i] > 0) // Draw the light
            {
                for (LightObject light : _channel.get(i)) {
                    if (light.image != null) {
                        g2.drawImage(light.image, light.x, light.y, null);
                    }
                }
            }
        }
    }

    public void WriteIO(int value) {
        int clock = value & 0x01;
        int latch = (value >> 1) & 0x01;

        // Simulate a bank of 5 x 74HC595 shift registers
        if (clock != _clock && clock > 0) {
            _register[0] = (_register[0] << 1) | ((value >> 2) & 0x01);
            _register[1] = (_register[1] << 1) | ((value >> 3) & 0x01);
            _register[2] = (_register[2] << 1) | ((value >> 4) & 0x01);
            _register[3] = (_register[3] << 1) | ((value >> 5) & 0x01);
            _register[4] = (_register[4] << 1) | ((value >> 6) & 0x01);
        }

        // Latch the register data to the outputs of each shift register
        if (latch != _latch && latch > 0) {
            for (int i = 0; i < 8; i++) // 74HC595 1
            {
                _output[i] = (_register[0] >> i) & 0x01;
            }
            for (int i = 8; i < 16; i++) // 74HC595 2
            {
                _output[i] = (_register[1] >> i - 8) & 0x01;
            }
            for (int i = 16; i < 24; i++) // 74HC595 3
            {
                _output[i] = (_register[2] >> i - 16) & 0x01;
            }
            for (int i = 24; i < 32; i++) // 74HC595 4
            {
                _output[i] = (_register[3] >> i - 24) & 0x01;
            }
            for (int i = 32; i < 40; i++) // 74HC595 5
            {
                _output[i] = (_register[4] >> i - 32) & 0x01;
            }

            repaint(); // Update canvas object
        }

        _clock = clock;
        _latch = latch;
    }
}
