import p2t
import re, sys

def load_prov_vertices(pv_fname):
    vertices = []
    with open(pv_fname) as f:
        for line in f.readlines():
            match = re.search(r'{(.*), (.*)}', line)
            point = (float(match.group(1)), float(match.group(2)))
            vertices.append(point)
    return vertices


def lookup(vertices, point):
    return vertices.index((round(point.x, 6), round(point.y, 6)))


def main(pv_fname, prov_fname):
    vertices = load_prov_vertices(pv_fname)

    with open(prov_fname) as p:
        for line in p.readlines():
            name, data = line.split(',')
            cdt = p2t.CDT([p2t.Point(*map(float, point.split(':')))
                           for point in data.split(';')])
            print name
            for triangle in cdt.triangulate():
                print '%d, %d, %d,' % (
                    lookup(vertices, triangle.a), lookup(vertices, triangle.b),
                    lookup(vertices, triangle.c)
                )


if __name__ == "__main__":
    main(*sys.argv[1:])
