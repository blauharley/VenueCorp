class Categories
  @@main_trans = { 'Sport' => :sport, 'Kultur' => :culture, 'Kinder & Familie' => :family, 'Brauchtum & Feste' => :party, 'Kulinarium' => :eating, 'Sonstiges' => :misc }
  @@cats = { :sport => ['Wandern und Klettern', 'Reiten', 'Rad & Mountainbike', 'Motor', 'Laufen & Nordic Walking', 'Luft & Wasser', 'Ski Nordisch', 'Ski Alpin', 'Sonstiges'], 
               :culture => ['Ausstellungen', 'Oper, Operette, Musical', 'Musik', 'Tanz, Ballet', 'Film', 'Literatur', 'Neue Medien', 'Festivals', 'Kleinkunst', 'Theater', 'Vortrag, Diskussion', 'Sonstiges'], 
               :family => [], 
               :party => ['Ostern', 'Weihnachten', 'Silvester', 'Fasching', 'Sonnenwende', 'Bälle', 'Volksfeste', 'Umzüge', 'Almauftrieb', 'Sonstiges'], 
               :eating => [], 
               :misc => [] 
           }
  
  def self.get_main_cats 
    @@main_trans
  end
  
  def self.get_sub_cats main_cat
    @@cats[ @@main_trans[main_cat] ]
  end
  
  def self.get_main_cat_by_sub_cat sub_cat
    main_cat = ''
    @@cats.each do |k,array|
      for sub in array
        if sub_cat == sub
          main_cat = if @@main_trans.index(k) then @@main_trans.index(k).slice(0,@@main_trans.index(k).length) else '' end
        end
      end
    end
    main_cat
  end
  
end