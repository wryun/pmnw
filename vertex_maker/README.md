Some terrible stuff to generate the vectorised province locs.

Steps:

 - get an image file with black dots on it
 - extract the locations of the black dots using
   `vertex_extractor.py map.png map_with_vertex_nums.png > prov_vertices.struct`
 - use `map_with_vertex_nums.png` from the above step to define the actual
   province polygons in a CSV file (provname,34:25:65:74:35)
 - turn that CSV file into actual vector locations using
   `prov_index_to_vertex.py prov_by_index.csv > prov_by_vertex.csv`
 - generate the triangles for each province using
   `triangulate_provinces.py prov_vertices.struct prov_by_vertex.csv > ?`


