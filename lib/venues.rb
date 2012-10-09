class Venues
  @@main_trans = { 'Steiermark' => :styria, 'Burgenland' => :burgenland, 'Kärnten' => :carinthia, 'Tirol' => :tyrol, 'Salzburg' => :salzburg, 'Vorarlberg' => :vorarlberg, 'Oberösterreich' => :upper_austria, 'Niederösterreich' => :down_austria, 'Wien' => :vienna }
  @@venues = { :styria => [ "Schladming-Dachstein",
                            "Ramsau am Dachstein",
                            "Ausseerland-Salzkammergut",
                            "Alpenregion Nationalpark Gesäuse",
                            "Urlaubsregion Murtal",
                            "Hochsteiermark",
                            "Graz",
                            "Region Graz",
                            "Oststeiermark",
                            "Thermenland Steiermark",
                            "Süd-West Steiermark" ], 
                            
               :burgenland => [ "Neusiedler See",
                                "Sonnenland Mittelburgenland",
                                "Südburgenland" ],
                                
               :carinthia => [  "Hohe Tauern",
                                "Lieser-/Maltatal",
                                "Katschberg-Rennweg",
                                "Region Nockberge Bad Kleinkirchheim",
                                "Naturarena Kärnten – Gail-, Gitsch-, Lesachtal, Weissensee",
                                "Villach-Warmbad, Faaker See, Ossiacher See",
                                "Millstätter See",
                                "Wörthersee",
                                "Outdoorpark Oberdrautal",
                                "Erlebnisregion Hochosterwitz",
                                "Carnica-Region Rosental",
                                "Klopeiner See – Südkärnten",
                                "Lavanttal",
                                "Klagenfurt" ],
                                
               :tyrol => [      "Achensee",
                                "Alpbachtal & Tiroler Seenland",
                                "Erste Ferienregion im Zillertal",
                                "Ferienland Kufstein",
                                "Ferienregion Hohe Salve",
                                "Ferienregion TirolWest",
                                "Imst Tourismus",
                                "Innsbruck & seine Feriendörfer",
                                "Kaiserwinkl",
                                "Kitzbühel Tourismus",
                                "Kitzbüheler Alpen - Brixental",
                                "Kitzbüheler Alpen - St. Johann in Tirol",
                                "Lechtal",
                                "Mayrhofen",
                                "Naturparkregion Reutte",
                                "Osttirol",
                                "Ötztal Tourismus",
                                "Paznaun",
                                "Pillerseetal",
                                "Pitztal",
                                "Region Hall-Wattens",
                                "Seefeld",
                                "Serfaus-Fiss-Ladis",
                                "Silberregion Karwendel",
                                "St. Anton am Arlberg",
                                "Stubai Tirol",
                                "Tannheimer Tal",
                                "Tiroler Oberland",
                                "Tiroler Zugspitz Arena",
                                "Tux - Finkenberg",
                                "Wilder Kaiser",
                                "Wildschönau",
                                "Wipptal",
                                "Zell-Gerlos, Zillertal Arena" ],
                                
               :salzburg => [   "Fuschlsee",
                                "Gasteinertal",
                                "Großarltal",
                                "Hochkönig",
                                "Lungau",
                                "Ferienregion Nationalpark Hohe Tauern",
                                "Obertauern",
                                "Saalbach Hinterglemm",
                                "Saalfelden-Leogang",
                                "Salzburg & Umgebungsorte",
                                "Salzburger Saalachtal",
                                "Salzburger Seenland",
                                "Salzburger Sonnenterrasse",
                                "Salzburger Sportwelt",
                                "Tennengau-Dachstein West",
                                "Wolfgangsee",
                                "Zell am See - Kaprun",
                                "Bischofshofen",
                                "Forstau",
                                "Goldegg",
                                "Hüttau-Niedernfritz",
                                "Maishofen",
                                "Pfarrwerfen",
                                "Viehhofen",
                                "Werfen",
                                "Werfenweng",
                                "Bürmoos",
                                "Nussdorf am Haunsberg",
                                "Lamprechtshausen",
                                "St. Georgen bei Salzburg" ],
                                
               :vorarlberg => [ "Kleinwalsertal",
                                "Bregenzerwald",
                                "Bodensee-Vorarlberg",
                                "Montafon",
                                "Alpenregion Bludenz",
                                "Arlberg",
                                "Biosphärenpark Großes Walsertal" ],
                                
               :upper_austria => [  "Salzkammergut",
                                    "Donau Oberösterreich",
                                    "Mühlviertel",
                                    "Innviertel",
                                    "Nationalpark Kalkalpen",
                                    "Dachstein Salzkammergut",
                                    "Pyhrn-Priel",
                                    "Vitalwelt - Bad Schallerbach",
                                    "Wolfgangsee",
                                    "Attersee",
                                    "Traunsee",
                                    "Mondsee",
                                    "Bad Hall - Kremsmünster",
                                    "Böhmerwald" ],
                                    
               :down_austria => [   "Donau-Niederösterreich",
                                    "Mostviertel",
                                    "Weinviertel",
                                    "Waldviertel",
                                    "Wienerwald",
                                    "Wiener Alpen" ],
                                    
               :vienna => []              
           }
  
  def self.get_federal_countries 
    @@main_trans
  end
  
  def self.get_venues federal_countries 
    @@venues[ @@main_trans[federal_countries ] ]
  end
  
  def self.get_federal_countries_by_vene venue
    federal_country = ''
    @@venues.each do |k,array|
      for ven in array
        if venue == ven
          federal_country = if @@main_trans.index(k) then @@main_trans.index(k).slice(0,@@main_trans.index(k).length) else '' end
        end
      end
    end
    federal_country
  end
  
end