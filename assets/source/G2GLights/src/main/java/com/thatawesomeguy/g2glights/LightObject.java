package com.thatawesomeguy.g2glights;

import java.awt.image.BufferedImage;

public class LightObject {
    public int x;
    public int y;
    public BufferedImage image;

    public LightObject() {
        this.x = 0;
        this.y = 0;
        this.image = null;
    }

    public LightObject(BufferedImage img) {
        this.x = 0;
        this.y = 0;
        this.image = img;
    }
}
