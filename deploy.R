rsconnect::deployApp(appFiles = c(
    './ui.R',
    './server.R',
    './maps/Map_Pt01.png',
    './maps/Map_Pt02.png',
    './maps/Map_Pt03.png',
    './maps/Map_Pt04.png',
    './maps/Map_Pt05.png',
    './maps/Map_Pt06.png',
    './maps/Map_Pt07.png',
    './maps/Map_Pt08.png',
    './maps/Map_Pt09.png',
    './maps/Map_Pt10.png',
    './grids/Grids.Rdata',
    './results/RSA/OpeningWindow/raw/Dilkina/growl2/allitems/performance/final_weights.Rdata'
    ),
    appName = 'ECoG_Visualization',
    account = 'crcox'
)
