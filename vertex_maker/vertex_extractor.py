import sys

from PIL import Image, ImageDraw, ImageFont

SCALE = 10


def rescale((x, y), (width, height)):
    return (
        (float(x) / (width - 1) * 2 - 1),
        -1 * (float(y) / (height - 1) * 2 - 1)
    )


def main(input_map, output_map):
    im = Image.open(input_map)
    
    (width, height) = im.size
    big_im = im.resize((SCALE * width, SCALE * height))
    draw = ImageDraw.Draw(big_im)
    font = ImageFont.load_default()
    i = 0

    for x in xrange(width):
        for y in xrange(height):
            red, green, blue, alpha = im.getpixel((x, y))

            if not any((red, green, blue)):
                draw.text((x * SCALE, y * SCALE), str(i),
                          fill=(200, 0, 0), font=font)
                i += 1
                print '    {%f, %f},' % rescale((x, y), (width, height))

    big_im.save(output_map)


if __name__ == "__main__":
    main(*sys.argv[1:])
