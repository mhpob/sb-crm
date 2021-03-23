library(sf); library(ggplot2); library(ggspatial)

st_layers('spatial/proposal_sites.gpkg')

points <- st_read('spatial/proposal_sites.gpkg',
                  layer = 'proposal_sites')
points$site_type <- ifelse(points$site_type == 'pound net', 'Pound net, pens',
                           ifelse(points$site_type == 'vr2ar', 'VR2AR receiver',
                                  'mobile'))

mobile_box <- st_read('spatial/proposal_sites.gpkg',
                      layer = 'mobile_telemetry_region')

river <- st_read('spatial/proposal_sites.gpkg',
                 layer = 'midatlantic')

coast <- st_read('spatial/proposal_sites.gpkg',
                 layer = 'usa_states')


main <-
  ggplot() +
  geom_sf(data = river, fill = 'gray99') +
  geom_sf(data = mobile_box, fill = NA, color = 'blue') +
  geom_sf(data = points[points$site_type != 'mobile',],
          aes(fill = site_type),
          size = 5, shape = 25) +
  geom_sf(data = points[points$site_type == 'mobile',]) +
  coord_sf(xlim = c(-76.71,-76.37), ylim = c(38.28, 38.7)) +
    labs(fill = NULL) +
  annotation_scale() +
  theme_bw() +
    theme(legend.position = c(0.25, 0.2),
          legend.background = element_blank(),
          plot.margin = margin(0, 0, 0, 0))


inset <-
  ggplot() +
  geom_sf(data = coast, fill = 'gray99') +
  coord_sf(xlim = c(-79, -74.8), ylim = c(34, 41)) +
  annotate('rect',
           xmin = -76.71, xmax = -76.37, ymin = 38.28, ymax = 38.7,
           fill = NA, color = 'blue') +
  theme_bw()+
  theme(plot.margin = margin(0, 0, 0, 0),
        plot.background = element_rect(fill = 'white'),
        axis.text.x = element_text(angle = 30, hjust = 1),
        panel.grid = element_blank())

library(cowplot); library(ragg)

agg_png('proposal_fig1.png', res = 100, width = 600, height = 885, scaling = 1.1)

main + draw_plot(inset, -76.529, 38.52, 0.2, 0.2)

dev.off()

