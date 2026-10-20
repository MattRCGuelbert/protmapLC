
library(jsonlite)
library(sf)
library(xml2)





qu <- st_read("05718_10_04_CD8.geojson")

cal <- qu[grepl("^calib[0-9]+$", qu$name), ]
cal <- cal[order(as.integer(sub("^calib", "", cal$name))), ]
polys <- qu[st_geometry_type(qu) %in% c("POLYGON", "MULTIPOLYGON"), ]
doc <- xml_new_root("ImageData")
xml_add_child(doc, "GlobalCoordinates", "3")

for (i in seq_len(nrow(cal))) {
  xy <- unname(st_coordinates(cal[i, ])[1, 1:2])
  xml_add_child(doc, paste0("X_CalibrationPoint_", i), xy[1])
  xml_add_child(doc, paste0("Y_CalibrationPoint_", i), -xy[2])
}

xml_add_child(doc, "ShapeCount", nrow(polys))

for (i in seq_len(nrow(polys))) {
  xy <- unname(st_coordinates(polys[i, ])[, 1:2, drop = FALSE])
  shape <- xml_add_child(doc, paste0("Shape_", i))
  xml_add_child(shape, "PointCount", nrow(xy))
  for (j in seq_len(nrow(xy))) {
    xml_add_child(shape, paste0("X_", j), xy[j, 1])
    xml_add_child(shape, paste0("Y_", j), -xy[j, 2])
  }
}

write_xml(doc, "output_file.xml")



