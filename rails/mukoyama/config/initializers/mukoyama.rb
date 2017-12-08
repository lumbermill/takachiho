module Mukoyama
  DOWNLOAD_DIR = "/var/www/mukoyama/downloads"

  # See http://openweathermap.org/help/city_list.txt for IDs.
  CITY_IDS = {
    Tokyo: 1850147,Osaka_shi: 1853909, Toyonaka: 1849837, Nishinomiya: 1855207,
    Kashima_shi: 1860748, Tsukuba: 2110683, Saitama: 6940394, Nagoya: 1856057,
    Miyazaki: 1856717, Nobeoka: 1855095, Hinokage:1862588, Owase: 1853514,
    Gifu: 1863641, Tsu:1849796, Toyohashi: 1849846, Takayama: 1850892,
    Yokkaichi: 1848373, Takatoricho: 1850924
  }

  CITY_NAMES = {
    Tokyo: "東京",Osaka_shi: "大阪市", Toyonaka: "豊中", Nishinomiya: "西宮",
    Kashima_shi: "鹿嶋市", Tsukuba: "筑波", Saitama: "埼玉", Nagoya: "名古屋",
    Miyazaki: "宮崎", Nobeoka: "延岡", Hinokage: "日之影", Owase: "尾鷲",
    Gifu: "岐阜", Tsu: "津", Toyohashi: "豊橋", Takayama: "高山",
    Yokkaichi: "四日市", Takatoricho: "鷹取町"
  }
end
