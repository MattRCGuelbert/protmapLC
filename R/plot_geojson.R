
library(ggplot2)

qu <- st_read("05718_10_04_CD8.geojson")

polys <- qu[st_geometry_type(qu) %in% c("POLYGON", "MULTIPOLYGON"), ]

points <- lapply(seq_len(nrow(polys)), function(i) {
  xy <- st_coordinates(polys[i, ])[, 1:2, drop = FALSE]
  data.frame(annotation_name = polys$name[i], x_point = xy[, 1], y_point = xy[, 2])
})

polygon_points <- do.call(rbind, points)
rownames(polygon_points) <- NULL
polygon_points$y_point <- polygon_points$y_point * -1


ggplot(polygon_points,aes(x=x_point,y=y_point,group=annotation_name,fill=annotation_name)) +
  geom_polygon(color="gray") +
  theme_classic() + theme(legend.position="none")
