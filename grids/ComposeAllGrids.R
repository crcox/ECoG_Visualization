source('defineGrid.R')
source('GridPoints_Pt01.R')
source('GridPoints_Pt02.R')
source('GridPoints_Pt03.R')
source('GridPoints_Pt05.R')
source('GridPoints_Pt07.R')
source('GridPoints_Pt08.R')
source('GridPoints_Pt09.R')
source('GridPoints_Pt10.R')
Grids <- rbind(
    GridPoints_Pt01(),
    GridPoints_Pt02(),
    GridPoints_Pt03(),
    GridPoints_Pt05(),
    GridPoints_Pt07(),
    GridPoints_Pt08(),
    GridPoints_Pt09(),
    GridPoints_Pt10()
)
Grids <- dplyr::rename(Grids, xr=x, yr=y)
Grids$labels <- as.factor(Grids$labels)
Grids$grid <- as.factor(Grids$grid)
save('Grids', file='Grids.Rdata')
