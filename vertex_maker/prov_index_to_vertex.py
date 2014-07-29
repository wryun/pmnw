import sys, re


def load_prov_vertices(pv_fname):
    vertices = []
    with open(pv_fname) as f:
        for line in f.readlines():
            match = re.search(r'{(.*), (.*)}', line)
            point = (float(match.group(1)), float(match.group(2)))
            vertices.append(point)
    return vertices


def main(pv_fname, prov_by_index_fname):
    vertices = load_prov_vertices(pv_fname)
    with open(prov_by_index_fname) as p:
        for line in p.readlines():
            name, data = line.split(',')
            print '%s,%s' % (name, ';'.join(
                '%f:%f' % vertices[int(v_index)] for v_index in data.split(';')
            ))


if __name__ == "__main__":
    main(*sys.argv[1:])
