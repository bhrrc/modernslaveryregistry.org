class InsertIndustriesFromSpreadsheet < ActiveRecord::Migration[5.0]
  def up
    spreadsheet_data.split("\n").reverse.each do |line|
      line =~ /^\s*([^,]+)\s*,(.+)$/
      company_name = mega_strip($1)
      industry_name = mega_strip($2)
      set_company_industry(company_name, industry_name)
    end
  end

  def delete_company(id)
    company = Company.find_by_id(id)
    if company
      company.delete
    else
      puts "Failed to delete company: #{id}"
    end
  end

  def set_company_industry(company_name, industry_name)
    puts "Updating '#{company_name}' to '#{industry_name}'..."
    company = find_company(company_name)
    company.update!(industry: find_industry(industry_name))
    puts "Updated '#{company_name}' to '#{industry_name}'"
  rescue => e
    puts e
    #binding.pry
    #raise e if @q
  end

  def find_company(name)
    exact_company = Company.where(name: name).first
    return exact_company unless exact_company.nil?
    companies = Company.where("name ilike ?", "%#{name}%")
    if companies.size == 0
      suggestions = Company.where("name ilike ?", "%#{name.split(' ')[0..1].join(' ')}%").map(&:name).inspect
      raise "No companies with name '#{name}' (suggestions: #{suggestions})"
    end
    unless companies.size == 1
      raise "#{companies.size} companies with name '#{name}'"
    end
    companies.first
  end

  def quit
    @q = true
    raise 'quit!'
  end

  def mega_strip(string)
    string.gsub(/^[[:space:]]+/, '').gsub(/[[:space:]]+$/, '')
  end

  def find_industry(name)
    industry = Industry.find_by(name: name)
    raise "no industry with name '#{name}'" unless industry
    industry
  end

  def spreadsheet_data
    %{Pitney Bowes Inc,Commercial Services & Supplies
      AET Tanker Holdings Sdn Bhd ,Oil, Gas & Consumable Fuels
      Aioi Nissay Dowa Insurance Company Of Europe Ltd,Insurance
      Amada United Kingdom Limited ,Machinery
      Avon Rubber p.l.c,Aerospace & Defense
      Bagnalls Group,Construction & Engineering
      BASF plc,Chemicals
      Bestway (Holdings) Limited,Industrial Conglomerates
      Bestway Wholesale Limited,Food & Staples Retailing
      BJSS Limited,IT Services
      Bloor Homes Ltd,Household Durables
      BMJ Publishing Group Limited,Media
      Brace's Bakery Limited,Food Products
      British United Provident Association Limited (Bupa),Insurance
      Cheval Residences Limited,Real Estate Management & Development
      Clifford Chance LLP,Professional Services
      Daisy Group Holdings Limited,Diversified Telecommunication Services
      Donaldson UK Holding Limited,Machinery
      East Kent Hospitals University NHS Foundation Trust,Health Care Providers & Services
      EPC United Kingdom plc,Industrial Conglomerates
      Exloc Instruments UK Ltd ,Electronic Equipment, Instruments & Components
      FactSet Research Systems Inc,Capital Markets
      Frontier Agriculture Limited ,Commercial Services & Supplies
      Gemalto N.V,Software
      Gerald Eve LLP,Real Estate Management & Development
      Hadley Industries Holdings Limited,Metals & Mining
      Harrison Catering Services Limited,Commercial Services & Supplies
      Hellmann Worldwide Logistics Limited,Air Freight & Logistics
      IRIS Software Group Ltd,Software
      JTI UK Ltd,Tobacco
      Jungheinrich UK Limited,Machinery
      Kurt Geiger Ltd,Specialty Retail
      LyondellBasell Industries N.V,Chemicals
      Masstock Arable (UK) Ltd. (t/a Agrii),Food Products
      Meggitt plc,Electronic Equipment, Instruments & Components
      Metropolitan Housing Trust Limited,Real Estate Management & Development
      Nielsen Holdings plc ,Professional Services
      Nokia Corporation,Communications Equipment
      Nurse Plus and Carer Plus UK Limited,Health Care Providers & Services
      Porterbrook Leasing Mid Company Limited,Trading Companies & Distributors
      RES Group (Renewable Energy Systems Ltd.),Independent Power and Renewable Electricity Producers
      Rhenus Logistics Limited ,Air Freight & Logistics
      Scottish Midland Co-operative Society Ltd,Food & Staples Retailing
      Trainline.com Limited,Internet & Direct Marketing Retail
      Travelers Management Limited,Insurance
      University of Southampton ,Diversified Consumer Services
      2M Holdings Ltd,Distributors
      3i Group plc,Capital Markets
      3M United Kingdom plc,Chemicals
      5 Boroughs Partnership NHS Foundation Trust,Health Care Providers & Services
      A B Graphic International Ltd,Machinery
      A Gomez Ltd,Distributors
      A J & R G Barber Ltd,Food Products
      A Nelson & Co Limited,Pharmaceuticals
      A-Plan Holdings Ltd,Insurance
      A. E. Yates Ltd,Construction & Engineering
      A. Schulman Inc. ,Chemicals
      A.G. BARR plc,Beverages
      A.J.N. Steelstock Ltd,Metals & Mining
      A&P Group Ltd,Marine
      A1 Engineering Solutions Ltd,Construction & Engineering
      A2Dominion Housing Group Ltd,Real Estate Management & Development
      AA plc,Diversified Consumer Services
      AAH Pharmaceuticals Limited,Health Care Providers & Services
      AAK AB,Food Products
      Aalco Metals Limited,Metals & Mining
      AB Agri Ltd,Distributors
      Abacus e-Media,Media
      Abatec Staff Consultants Limited,Professional Services
      ABB Ltd,Electrical Equipment
      Abbey Developments Limited,Household Durables
      Abbey Logistics Group Limited,Road & Rail
      AbbVie Ltd,Biotechnology
      ABC Electrification Limited,Construction & Engineering
      ABC International Bank Plc,Banks
      Abcam plc,Biotechnology
      Abel & Cole Limited,Internet & Direct Marketing Retail
      Abellio Greater Anglia,Road & Rail
      Aberystwyth University,Diversified Consumer Services
      ABi Associates,Media
      ABInBev UK Limited,Beverages
      ABM Industries Incorporated,Commercial Services & Supplies
      Academia Ltd,Electronic Equipment, Instruments & Components
      Acal plc,Electronic Equipment, Instruments & Components
      Accenture (UK) Limited,Professional Services
      Access UK Ltd,Software
      Accesso Technology Group Plc,Electronic Equipment, Instruments & Components
      Accolade Wines Limited,Beverages
      Accord Healthcare Ltd,Pharmaceuticals 
      Accord Housing Association Ltd,Health Care Providers & Services
      Accrol Group Holdings limited,Household Products
      Accsys Technologies Plc,Paper & Forest Products
      Acheson Holdings Limited,Construction Materials
      Achilles Holdco Limited,Internet Software & Services
      Acorn Group,Real Estate Management & Development
      Acorn Mobility Services Ltd,Health Care Equipment & Supplies
      ACS International Schools Ltd,Diversified Consumer Services
      Acteon Group Limited,Energy Equipment & Services
      Actis LLP,Capital Markets
      Activision Blizzard Inc,Software
      Acturis Group Limited,Software
      Acushnet Group,Leisure Products
      Adactus Housing Group,Real Estate Management & Development
      Adam Smith International,Professional Services
      Adare SEC Limited,Media
      Addleshaw Goddard LLP,Professional Services
      Addo Food Group,Food Products
      adidas (UK) Limited,Leisure Products
      Adler and Allan Holdings Limited,Commercial Services & Supplies
      ADM (Group) Limited,Media
      Admiral Group plc,Insurance
      Admiral Taverns,Hotels, Restaurants & Leisure
      Adnams plc,Beverages
      Adobe Systems Europe Limited,IT Services
      ADP LLC,IT Services
      Advance Uranium Asset Management Limited,Metals & Mining
      Advanced Computer Software Group Limited,Software
      Advanced Medical Solutions Group Plc,Health Care Equipment & Supplies
      Advanced Supply Chain,Air Freight & Logistics
      Advantage Resourcing UK,Professional Services
      Advantage Xpo Limited,Professional Services
      Advent International plc,Capital Markets
      AEGIS Managing Agency Limited,Insurance
      Aegon UK Group,Capital Markets
      AES Corporation,Independent Power and Renewable Electricity Producers
      AES Engineering Limited ,Machinery
      AESSEAL plc ,Machinery
      AFC Bournemouth Limited,Media
      AFE Group Ltd,Machinery
      Affinity Sutton,Diversified Financial Services
      Affinity Water Limited,Water Utilities
      AG Retail Cards Limited (t/a Clintons),Specialty Retail
      AGC Chemicals Europe Ltd,Chemicals
      Ageas (UK) Limited ,Insurance
      Agent Provocateur Ltd,Specialty Retail
      Agfa HealthCare UK Limited,Health Care Technology
      Aggregate Industries UK Ltd,Construction Materials
      Aggreko plc,Commercial Services & Supplies
      Agilisys Limited,IT Services
      AGS Airports Limited,Transportation Infrastructure
      AGT Poortman,Food & Staples Retailing
      Aico Limited,Commercial Services & Supplies
      AIG Europe Limited,Insurance
      Aintree University Hospital NHS Foundation Trust,Health Care Providers & Services
      Air Canada,Airlines
      Air Charter Service Limited,Air Freight & Logistics
      Air New Zealand Limited,Airlines
      Air Products and Chemicals,Chemicals
      Airbus Operations Ltd,Aerospace & Defense
      Aircelle Limited,Aerospace & Defense
      Airedale Chemical Company Limited,Chemicals
      Airedale International Air Conditioning Ltd,Electrical Equipment
      Airswift Holdings Limited,Professional Services
      Airwair International Ltd (Dr Martens),Textiles, Apparel & Luxury Goods
      Ajilon (UK) Limited,IT Services
      AK Steel Corporation,Metals & Mining
      Aker Solutions ASA,Energy Equipment & Services
      Aktrion Holdings,Professional Services
      Akzo Nobel,Chemicals
      Alan Bartlett & Sons (Chatteris) Ltd,Food Products
      Alan Nutall Partnership Ltd,Commercial Services & Supplies
      Albemarle Corporation,Chemicals
      Albert Bartlett,Food Products
      Albourne Partners Limited,Capital Markets
      Alcon Eye Care UK Limited,Health Care Equipment & Supplies
      ALD Automotive Group,Diversified Consumer Services
      Alderley,Energy Equipment & Services
      Aldermore Group,Banks
      Alderwood Education Limited,Diversified Consumer Services
      Aldi Stores Ltd,Food & Staples Retailing
      Alexander Dennis Limited,Machinery
      Alfa Financial Software Limited,Internet Software & Services
      Alfa Laval Corporate AB,Machinery
      Alfa Leisureplex Group,Hotels, Restaurants & Leisure
      Alfred Dunhill Limited,Textiles, Apparel & Luxury Goods
      All Saints Retail Limited,Specialty Retail
      All Steels Trading Limited,Trading Companies & Distributors
      Allen & Overy LLP,Professional Services
      Allen Lane Limited,Professional Services
      Allergan Ltd. ,Pharmaceuticals
      Alliance Automotive UK Limited,Distributors
      Alliance Medical Group Limited ,Health Care Providers & Services
      Alliance Pharma plc,Pharmaceuticals
      Alliancebernstein Limited,Capital Markets
      Allianz Holdings plc,Insurance
      Allied Healthcare,Health Care Providers & Services
      Allied Irish Banks,Banks
      Allied Milling and Baking,Food Products
      Allies and Morrison LLP,Construction & Engineering
      Allocate Software Limited,Health Care Technology
      Allport Cargo Services Limited,Air Freight & Logistics
      Allstar Business Solutions Limited,IT Services
      Allstate Northern Ireland,Insurance
      Almac Group Limited,Life Sciences Tools & Services
      Alphabet (GB) Limited,Road & Rail
      Alpine Electronics of UK Ltd,Household Durables
      ALPS ELECTRIC EUROPE GmbH,Electrical Equipment
      Alstom Transport Uk Limited,Machinery
      Alternative Networks Plc,Diversified Telecommunication Services
      Altodigital Networks Ltd,Commercial Services & Supplies
      Altran UK Limited,IT Services
      Altus Group Limited,Real Estate Management & Development
      Alumasc Group plc (The),Building Products
      Alun Griffiths (Contractors) Limited,Construction & Engineering
      Amalgamated Construction Ltd,Construction & Engineering
      Amalgamated Metal Corporation plc,Metals & Mining
      Amari Plastics Plc ,Trading Companies & Distributors
      Ambition Europe Limited,Professional Services
      Ambitions Personnel Limited,Professional Services
      Amcor Limited,Household Durables
      AMD Contract Services Limited,Machinery
      Amec Foster Wheeler,Energy Equipment & Services
      Amer Sports Corporation,Leisure Products
      America Fujikura Ltd (AFL),Communications Equipment
      American Apparel,Textiles, Apparel & Luxury Goods
      American Express,Diversified Financial Services
      Amerisur Resources plc,Oil, Gas & Consumable Fuels
      AMETEK,Electrical Equipment
      Amey UK plc,Transportation Infrastructure
      AMG Aluminum UK Limited,Metals & Mining
      Amicus Finance PLC,Diversified Financial Services
      AmicusHorizon,Real Estate Management & Development
      AMP Capital Holdings Limited,Capital Markets
      Amphenol Corporation,Electronic Equipment, Instruments & Components
      Amtico International Limited,Building Products
      AmTrust International Limited,Insurance
      ANA Group,Airlines
      Analog Devices Inc,Semiconductors & Semiconductor Equipment
      Anderselite Limited,Professional Services
      Angel Trains Limited,Road & Rail
      Anglia Components Ltd,Electronic Equipment, Instruments & Components
      Anglia Farmers Limited,Food Products
      Anglia Ruskin University ,Diversified Consumer Services
      Anglian Water Services Ltd,Water Utilities
      Anglian Windows Ltd,Building Products
      Anglo American plc,Metals & Mining
      Anglo Beef Processors (UK) Limited,Food Products
      Angus Soft Fruits,Food Products
      Anixter Limited,Electronic Equipment, Instruments & Components
      Annodata Ltd,IT Services
      Ans Group Limited,Software
      Antofagasta plc,Metals & Mining
      Anwyl Construction Company Ltd,Construction & Engineering
      ANZ Group,Banks
      AO World plc,Internet & Direct Marketing Retail
      Aon UK Limited,Insurance
      AOP Orphan Pharmaceuticals AG,Pharmaceuticals
      Apache Corporation,Oil, Gas & Consumable Fuels
      Apax Partners LLP,Capital Markets
      APCOA Parking (UK) Group,Commercial Services & Supplies
      API Group plc,Paper & Forest Products
      APM UK LTD,Professional Services
      Apogee Corporation Limited,IT Services
      Apple Inc,Technology Hardware, Storage & Peripherals
      Appleby Westward Group Limited,Food & Staples Retailing
      APS Group,Commercial Services & Supplies
      Aquila Heywood Group Limited,Software
      Aquilant Limited,Health Care Providers & Services
      Aramark Limited,Hotels, Restaurants & Leisure
      Aramex UK Limited,Air Freight & Logistics
      Arawak Business Consulting Limited,Professional Services
      Arbor Forest Products Limited,Paper & Forest Products
      Arcadia Group Ltd,Specialty Retail
      Arcadis UK ,Professional Services
      ArcelorMittal,Metals & Mining
      Arco Limited,Distributors
      Arcus Infrastructure Partners Llp,Capital Markets
      Ardagh Metal Packaging UK Limited,Containers & Packaging
      Ardent Hire Solutions Limited,Trading Companies & Distributors
      Argent Foods Limited,Food Products
      Argent Group Europe Limited,Food Products
      Argo Managing Agency Limited,Insurance
      Argus Media Limited,Media
      Ari Fleet UK Ltd,Road & Rail
      Armitage Pet Products Limited,Specialty Retail
      Arnold Clark Automobiles Limited,Specialty Retail
      Arnold Laver & Co. Ltd. ,Paper & Forest Products
      Arora Holdings Limited,Real Estate Management & Development
      Arqiva Group,Media
      Arran Isle Group,Building Products
      Arran Isle Limited,Building Products
      Arrandene MFG Ltd,Metals & Mining
      ARRC Holdings Limited,Air Freight & Logistics
      Arriva plc,Road & Rail
      Arrow Electronics Inc,Electronic Equipment, Instruments & Components
      Arrow Global Group Plc,Diversified Financial Services
      Arrow XL Ltd,Road & Rail
      Arrowgrass Capital Partners UK LLP,Capital Markets
      Arsenal Holdings PLC,Media
      Artemis Group,Capital Markets
      Artizian Catering Limited,Hotels, Restaurants & Leisure
      Arts and Humanities Research Council (AHRC),Professional Services
      Arts University Bournemouth,Diversified Consumer Services
      Arup Group Limited,Professional Services
      Arval UK Group Limited,Specialty Retail
      Arvato UK,IT Services
      Asbestos Consultants Europe Limited,Professional Services
      Ascential plc,Media
      ASCO Group Limited,Energy Equipment & Services
      Ascot Group,Insurance
      Asda Stores Limited,Food & Staples Retailing
      Ashe Construction Ltd,Machinery
      Ashford and St Peter’s Hospital NHS Foundation Trust,Health Care Providers & Services
      Ashmore Group plc,Capital Markets
      Ashtead Plant Hire Co Ltd,Trading Companies & Distributors
      Ashurst LLP,Professional Services
      ASICS Corporation,Textiles, Apparel & Luxury Goods
      ASML,Semiconductors & Semiconductor Equipment
      Asos,Internet & Direct Marketing Retail
      Aspect Capital Limited,Capital Markets
      Aspen Insurance UK Limited,Insurance
      Aspers UK Holdings Limited,Hotels, Restaurants & Leisure
      Aspin Group Ltd,Construction & Engineering
      Aspire Housing,Real Estate Management & Development
      Asset Advantage Limited,Diversified Financial Services
      Assist Resourcing UK Ltd ,Professional Services
      Associated British Foods plc,Food Products
      Associated British Ports,Transportation Infrastructure
      Assura plc,Equity Real Estate Investment Trusts (REITs)
      Assurant Group Limited,Insurance
      Assystem Group UK Ltd,Construction & Engineering
      Asta Capital Limited,Professional Services
      Astellas Pharma Inc,Pharmaceuticals
      Astex Therapeutics Limited,Pharmaceuticals
      Astins Ltd,Construction & Engineering
      Aston Manor Cider,Beverages
      Aston University,Diversified Consumer Services
      AstraZeneca plc,Pharmaceuticals
      Astute Technical Recruitment Limited,Professional Services
      Asustek Computer Inc ,Technology Hardware, Storage & Peripherals
      ATI Specialty Materials Limited,Metals & Mining
      Atlas Copco Limited,Machinery
      Atlas Elektronik UK Limited,Aerospace & Defense
      Atos,IT Services
      ATPI,Hotels, Restaurants & Leisure
      Atrium Underwriters Ltd,Insurance
      Attend,IT Services
      Audi AG,Automobiles
      Audiotonix Limited,Household Durables
      Augean plc,Commercial Services & Supplies
      AUMA Riester GmbH & Co. KG,Machinery
      Aurionpro Solutions,IT Services
      Aurum Group Limited,Specialty Retail
      Australian Vintage Limited,Beverages
      Auto Trader Group plc,Internet Software & Services
      Autoliv Inc,Auto Components
      Autonet Insurance Services Ltd (t/a Autonet Insurance Group),Insurance
      Autoneum Great Britain Ltd. (UK),Auto Components
      Avanade UK Limited,IT Services
      Avant Homes Holdings Limited,Household Durables
      Avaya,Software
      Avery Dennison UK,Containers & Packaging
      Aveva Group plc,Software
      Aviagen,Food Products
      Avidity Training Limited,Professional Services
      Avis Budget Car Rental LLC,Specialty Retail
      Aviva plc,Insurance
      AVL UK Limited,Auto Components
      Avnet,Electronic Equipment, Instruments & Components
      Avon Cosmetics Limited,Personal Products
      AXA Investment Managers UK Limited,Capital Markets
      AXA UK plc,Insurance
      Axalta  Coating Systems UK Limited,Chemicals
      Axians Networks Limited,IT Services
      Axis Cleaning and Support Services,Commercial Services & Supplies
      Axis Europe Plc,Commercial Services & Supplies
      Axle Group Holdings Limited,Auto Components
      Azzurri Group,Hotels, Restaurants & Leisure
      B & M Retail Limited,Multiline Retail
      B.G. Freight Line  Holding B.V,Marine
      B.Mason & Sons Limited,Metals & Mining
      B.W.O.C. Limited,Oil, Gas & Consumable Fuels
      B&M European Value Retail S.A,Multiline Retail
      Babcock & Wilcox Enterprises,Electrical Equipment
      Babcock International Group PLC,Commercial Services & Supplies
      Bacardi U.K. Limited,Beverages
      Bachem Holding AG,Pharmaceuticals
      Bachy Soletanche Limited,Construction & Engineering
      BackOffice Associates,Software
      Badenoch & Clark Limited,Professional Services
      BAE Systems plc,Aerospace & Defense
      Baillie Gifford Group,Capital Markets
      Bain & Company,Professional Services
      Bain Capital Private Equity (Europe),Capital Markets
      Baird Group Ltd (The),Specialty Retail
      Bakkavor Group PLC,Food Products
      Balfour Beatty plc,Construction & Engineering
      Ballyvesey Holdings Ltd,Industrial Conglomerates
      BAM Construct UK Ltd,Construction & Engineering
      BAM Nuttall Limited ,Construction & Engineering
      Bandai Namco Holdings Inc,Leisure Products
      Bang & Olufsen A/S,Household Durables
      Bangor University,Diversified Consumer Services
      Banham Poultry Limited,Food Products
      Bank of America Corporation,Banks
      Bank of Baroda,Banks
      Bank of Montreal,Banks
      Bank of New York Mellon Corporation (BNY Mellon),Banks
      Bank of Taiwan London Branch,Banks
      Banner Business Services Ltd,Commercial Services & Supplies
      Banner Plant Ltd,Trading Companies & Distributors
      Bar Foods,Food Products
      Barbican Group Holdings Limited,Insurance
      Barchester Healthcare Ltd,Health Care Providers & Services
      Barclays PLC,Banks
      Bardsley Construction Limited,Construction & Engineering
      Barentz International B.V,Food & Staples Retailing
      Barfoots of Botley Ltd,Food Products
      Barhale,Construction & Engineering
      Barings (U.K.) Limited,Capital Markets
      Barker Ross Group Ltd,Commercial Services & Supplies
      Barnes Group Limited,Construction & Engineering
      Barnett Waddingham LLP,Capital Markets
      Barnfield Group Limited,Construction & Engineering
      Barnsley College,Diversified Consumer Services
      Barratt Developments plc,Household Durables
      Barrett Steel Limited,Metals & Mining
      Barrhead Travel Service Ltd,Hotels, Restaurants & Leisure
      Barry Callebaut AG,Food Products
      Bartholomews Agri Food Limited,Distributors
      Base Performance Simulators,Commercial Services & Supplies
      Bath Spa University,Diversified Consumer Services
      Bausch + Lomb UK Ltd,Health Care Equipment & Supplies
      Baxi,Electrical Equipment
      Baxter Healthcare Ltd,Health Care Equipment & Supplies
      Baxters Food Group Limited,Food Products
      Baxterstorey Limited,Commercial Services & Supplies
      Bayer AG,Pharmaceuticals
      Bazelgette Tunnel Limited,Construction & Engineering
      BBA Aviation plc,Transportation Infrastructure
      BBC Worldwide Ltd,Media
      BBSRC (Biotechnology and Biological Sciences Research Council),Professional Services
      BCA Marketplace PLC,Specialty Retail
      BCEGI UK,Construction & Engineering
      BCM Scaffolding Services Limited,Construction & Engineering
      BCS,Professional Services
      BDO LLP,Diversified Financial Services
      Beachbody,Leisure Products
      Beale & Company Solicitors LLP,Professional Services
      Beale and Co,Professional Services
      Beam Suntory Inc,Beverages
      Beaver Management Services Limited (BMSL),Professional Services
      Beaver-Visitec International Holdings Inc,Health Care Equipment & Supplies
      Beaverbrooks The Jewellers Ltd,Specialty Retail
      Beazley plc,Insurance
      Bechtel Corporation,Construction & Engineering
      Beck & Pollitzer Ltd,Commercial Services & Supplies
      Becketts Foods Limited,Food Products
      Beechcroft Group Limited,Household Durables
      Beeswax Dyson Farming Limited,Food Products
      Beeswift Ltd,Distributors
      Begbies Traynor Group plc,Professional Services
      Beiersdorf UK Ltd,Household Products
      Belfield Furnishings Ltd,Household Durables
      Bell Truck and Van,Specialty Retail
      Bellway plc,Household Durables
      Belron International Limited,Commercial Services & Supplies
      Belron UK Limited,Diversified Consumer Services
      Bemis Company,Containers & Packaging
      Bennett Construction Ltd,Household Durables
      Bensons for Beds (Steinhoff),Specialty Retail
      BENTELER International ,Auto Components
      Berendsen plc,Commercial Services & Supplies
      Berendsen plc,Commercial Services & Supplies
      Berkeley Group Holdings plc,Household Durables
      Berkshire Healthcare NHS Foundation Trust,Health Care Providers & Services
      Bernard Matthews Holdings Limited,Food Products
      Berneslai Homes Limited,Real Estate Management & Development
      Berry Bros. & Rudd Limited,Beverages
      Berry Gardens,Food & Staples Retailing
      Berry Recruitment Group Ltd,Professional Services
      Berwin Leighton Paisner LLP,Professional Services
      Bespak Europe Limited,Professional Services
      BESTSELLER A/S,Textiles, Apparel & Luxury Goods
      Bettys & Taylors Group Ltd,Food Products
      Bevan Brittan LLP,Professional Services
      BEW Electrical Distributors Ltd,Electronic Equipment, Instruments & Components
      BFS Group Ltd,Food & Staples Retailing
      BGL Group Limited,Insurance
      BHP Billiton,Metals & Mining
      BI WORLDWIDE Ltd,Professional Services
      Bibby Distribution Limited,Air Freight & Logistics
      Bibby Financial Services Ltd,Diversified Financial Services
      Bibby Line Group Limited,Industrial Conglomerates
      Bibendum Wine Limited,Beverages
      Bidwells LLP,Real Estate Management & Development
      Biffa plc,Commercial Services & Supplies
      Big Yellow Group plc,Diversified Consumer Services
      Bilfinger Salamis UK Limited,Energy Equipment & Services
      BillerudKorsnas Beetham AB,Containers & Packaging
      Binding Site Group Limited (The),Life Sciences Tools & Services
      Bio-Rad Laboratories Inc,Life Sciences Tools & Services
      Bio-Techne Corporation,Life Sciences Tools & Services
      Biogen Inc,Biotechnology
      BioMarin Pharmaceutical Inc,Biotechnology
      Biomérieux Uk Ltd,Health Care Equipment & Supplies
      Biotage AB,Life Sciences Tools & Services
      Bircham Dyson Bell LLP,Professional Services
      Bird & Bird LLP,Professional Services
      Birkbeck College,Diversified Consumer Services
      Birketts LLP,Professional Services
      Birmingham Airport,Transportation Infrastructure
      Biwater Holdings Limited,Commercial Services & Supplies
      BL Claims Solicitors,Professional Services
      Black & Veatch Limited,Construction & Engineering
      BlackBerry Limited,Software
      Blackboard (UK) Limited,Diversified Consumer Services
      Blackburns Metals Limited,Trading Companies & Distributors
      Blackhawk Network Holdings ,IT Services
      Blackpool Pleasure Beach,Hotels, Restaurants & Leisure
      BlackRock Group Limited,Capital Markets
      Blackstone Group International Partners LLP (The),Capital Markets
      Bladeroom Holdings Limited,Construction & Engineering
      Blake Morgan LLP,Professional Services
      Blue Skies,Food Products
      BlueBay Asset Management LLP,Capital Markets
      Bluefin Insurance Services Limited,Insurance
      BMC Software Limited,Software
      BMT Defence Services Ltd,Construction & Engineering
      BMT Group Ltd,Construction & Engineering
      BMW Financial Services (GB) Limited,Automobiles
      BNP Paribas S.A.,Banks
      BNP Paribas Personal Finance,Consumer Finance
      BNP Paribas Real Estate,Real Estate Management & Development
      Bob Martin (UK) Ltd,Pharmaceuticals
      Bodycote plc,Machinery
      Boehringer Ingelheim Limited,Pharmaceuticals
      Boeing United Kingdom Limited,Aerospace & Defense
      Bokomo Foods (UK) Ltd,Food Products
      Bombardier Transportation (Global Holding) UK Ltd,Machinery
      Bombardier Transportation UK Ltd,Machinery
      Bond Dickinson LLP,Professional Services
      boohoo.com plc,Internet & Direct Marketing Retail
      Booker Group PLC,Food & Staples Retailing
      Boparan Holdings Ltd (t/a 2 Sisters Food Group),Food Products
      Borras Construction Ltd,Construction & Engineering
      Borras Construction Ltd,Construction & Engineering
      Bose Limited,Household Durables
      Boskalis Westminster Limited,Construction & Engineering
      Boss Design Limited,Household Durables
      Bostik Limited,Chemicals
      Boston Consulting Group UK LLP,Professional Services
      Boston Scientific Corporation,Health Care Equipment & Supplies
      Bottomline Technologies Ltd,Internet Software & Services
      Bourne Construction Engineering Ltd,Construction & Engineering
      Bournemouth University,Diversified Consumer Services
      Boutinot Limited,Beverages
      Bouygues (UK) Limited,Construction & Engineering
      Bouygues E&S Infrastructure UK Limited,Construction & Engineering
      Bovis Homes Group PLC,Household Durables
      BP plc,Oil, Gas & Consumable Fuels
      BPP Holdings Limited (BPP University),Diversified Consumer Services
      Bradfords Group (The),Household Durables
      Bradfords Group Limited,Specialty Retail
      Brady Corporation,Commercial Services & Supplies
      Braemar Shipping Services Plc,Transportation Infrastructure
      Brainlab UK,Health Care Technology
      Brake Bros Limited,Food & Staples Retailing
      Brambles Limited ,Commercial Services & Supplies
      Bramhalls Limited,Professional Services
      Brammer Plc,Trading Companies & Distributors
      Brand Energy & Infrastructure Services UK,Construction & Engineering
      Brand-Rex Limited,Communications Equipment
      Branston Limited,Food Products
      BRE Group,Professional Services
      Breedon Group plc,Construction Materials
      Breheny Group Limited,Construction & Engineering
      Brenntag UK Holdings Ltd,Trading Companies & Distributors
      Brevan Howard Asset Management LLP,Capital Markets
      Brewin Dolphin Holdings PLC,Capital Markets
      Breyer Group Plc,Household Durables
      Briar Chemicals Limited,Chemicals
      Bridge of Weir Leather Company,Textiles, Apparel & Luxury Goods
      Bridgepoint Group Limited,Capital Markets
      Bridgestone Industrial Limited,Trading Companies & Distributors
      Bridon International Limited,Metals & Mining
      Bridon-Bekaert the Ropes Group,Metals & Mining
      Briggs & Forrester Group Limited,Construction & Engineering
      Briggs & Stratton,Machinery
      Briggs Amasco Limited,Building Products
      Briggs Commercial Limited Group ,Commercial Services & Supplies
      Bright Blue Food Ltd,Food Products
      brighterkind,Diversified Consumer Services
      BrightHouse,Internet & Direct Marketing Retail
      Brightsource Ltd,Media
      Brightwork Limited,Professional Services
      Brintons Carpets Limited,Household Durables
      Bristan Group Limited,Building Products
      Bristol Airport Limited,Transportation Infrastructure
      Bristol Laboratories Ltd,Pharmaceuticals
      Bristol Water plc,Water Utilities
      Bristow Group Inc,Energy Equipment & Services
      Bristows LLP,Professional Services
      Brit European Transport Ltd,Road & Rail
      Britannia Pharmaceuticals Ltd,Pharmaceuticals
      Britannia Steam Ship Insurance Association Limited,Insurance
      Britax Group Limited,Leisure Products
      Britcon (UK) Limited,Construction & Engineering
      British American Tobacco plc,Tobacco
      British Arab Commercial Bank plc (BACB),Banks
      British Broadcasting Corporation (BBC),Media
      British Engineering Services Limited,Professional Services
      British Engines Limited,Energy Equipment & Services
      British Hospitality Association,Professional Services
      British Land Company Plc,Equity Real Estate Investment Trusts (REITs)
      British Medical Association,Commercial Services & Supplies
      British Steel Limited,Metals & Mining
      British Sugar Plc,Food Products
      British Telecommunications plc (BT),Diversified Telecommunication Services
      BritNed Development Limited,Electric Utilities
      Britvic plc,Beverages
      Broadland Wineries Ltd,Beverages
      Broadway Malyan Holdings Limited,Commercial Services & Supplies
      Brocade Communications Systems Inc,Communications Equipment
      Brodies LLP,Professional Services
      Broker Network Limited,Insurance
      Bromford Housing Group Limited,Real Estate Management & Development
      Brook Street UK Ltd,Professional Services
      Brookson Ltd,Professional Services
      Brother Industries (UK) Ltd,Technology Hardware, Storage & Peripherals
      Brother UK Ltd,Technology Hardware, Storage & Peripherals
      Brown Brothers Distribution Limited,Chemicals
      Brown-Forman Beverages Europe,Beverages
      Browne Jacobson,Professional Services
      BRS Limited,Road & Rail
      Brunel University London,Diversified Consumer Services
      Brush Electrical Machines Limited,Electrical Equipment
      Bruynzeel Storage Group BV,Commercial Services & Supplies
      Brymor Construction Ltd,Construction & Engineering
      BSN Medical Group,Health Care Equipment & Supplies
      BSW Timber Ltd,Paper & Forest Products
      BT Business Direct Ltd,IT Services
      BT Cables Limited,Electrical Equipment
      BT Fleet Limited,Diversified Telecommunication Services
      BT Lancashire Services Limited,Professional Services
      BTG plc,Pharmaceuticals
      Buckingham Group Contracting,Construction & Engineering
      Buckinghamshire New University,Diversified Consumer Services
      Buckley Sandler LLP,Professional Services
      Bugatti Automobiles S.A.S,Automobiles
      Build-A-Bear Workshop,Specialty Retail
      Builder Depot Limited,Household Durables
      Building Design Partnership Limited,Professional Services
      Bullitt Group,Technology Hardware, Storage & Peripherals
      Bulten Ltd,Specialty Retail
      Bumble and Bumble Products,Personal Products
      Bunzl plc,Distributors
      Buoyant Upholstery Limited,Household Durables
      Burberry,Textiles, Apparel & Luxury Goods
      BURG-WÄCHTER UK Limited,Building Products
      Burges Salmon LLP,Professional Services
      Burness Paull LLP,Professional Services
      Burnt Tree Group Limited,Road & Rail
      Buro Happold Limited,Construction & Engineering
      Burrows Motor Company,Specialty Retail
      Burton Roofing Merchants Ltd,Trading Companies & Distributors
      Burton's Biscuit Company (t/a Burtons Food Limited),Food Products
      BUUK Infrastructure No 1 Limited,Energy Equipment & Services
      BVG Group Limited,Multiline Retail
      BW Interiors Limited,Commercial Services & Supplies
      ByBox Holdings Limited,Software
      Bytes Technology Group,IT Services
      C. Brewer & Sons Limited,Specialty Retail
      C. Hoare & Co,Banks
      C.HAFNER,Metals & Mining
      C.J. O'Shea and Company Ltd,Household Durables
      C.J. O’Shea and Company Ltd,Household Durables
      C.J. Upton & Sons Ltd,Machinery
      C&W Berry Limited,Household Durables
      Cab Automotive Ltd,Auto Components
      Cable News International Limited ,Media
      Cabot Credit Management Group Limited,Commercial Services & Supplies
      CACI Limited,Media
      Caddick Construction Ltd,Construction & Engineering
      Cadogan Tate Group Ltd,Road & Rail
      Caesars Entertainment UK Ltd,Hotels, Restaurants & Leisure
      CALA Group (Holdings) Limited,Household Durables
      Calbee (UK) Limited,Food Products
      Calderdale and Huddersfield NHS Trust Foundation,Health Care Providers & Services
      Calea UK Limited,Pharmaceuticals
      Caledonian Modular Limited,Construction & Engineering
      Caledonian Plywood Company Ltd,Construction Materials
      Callcredit Information Group Ltd,Media
      Calon Energy Limited,Oil, Gas & Consumable Fuels
      Calor Gas Ltd,Oil, Gas & Consumable Fuels
      Calsonic Kansei Europe plc,Auto Components
      Cambria Automobiles Plc,Specialty Retail
      Cambridge University Press,Media
      Cambridge Weight Plan,Food Products
      Camellia Plc,Trading Companies & Distributors
      Camelot UK Lotteries Limited,Hotels, Restaurants & Leisure
      Camira Fabrics Limited,Textiles, Apparel & Luxury Goods
      Campbell Lutyens & Co. Ltd,Capital Markets
      Camping And Caravanning Club Limited (The),Hotels, Restaurants & Leisure
      CAN Geotechnical Ltd,Construction & Engineering
      Canaccord Genuity Limited,Capital Markets
      Canada Life Group (U.K.) Limited,Insurance
      Canada Life International Limited,Insurance
      Canadian Imperial Bank of Commerce,Banks
      Canadian Solar Inc,Semiconductors & Semiconductor Equipment
      Cancer Research Technology Limited,Life Sciences Tools & Services
      Canon UK Ltd,Electronic Equipment, Instruments & Components
      Canopius Managing Agents Limited,Insurance
      Cape plc,Commercial Services & Supplies
      Capgemini UK plc,IT Services
      Capita plc,Professional Services
      Capital & Counties Properties PLC,Real Estate Management & Development
      Capital & Regional plc,Equity Real Estate Investment Trusts (REITs)
      Capital Home Loans Ltd,Thrifts & Mortgage Finance
      Capital One (Europe) plc,Consumer Finance
      Capsticks Solicitors LLP,Professional Services
      Capula Investment Management LLP,Capital Markets
      Capula Ltd,IT Services
      Car Shops Limited,Specialty Retail
      Caravan and Motorhome Club Ltd,Hotels, Restaurants & Leisure
      Carclo PLC,Chemicals
      Card Factory PLC,Specialty Retail
      Cardano Risk Management Limited,Capital Markets
      Cardiff Metropolitan University,Diversified Consumer Services
      Cardiff University,Diversified Consumer Services
      Cardtronics Plc,IT Services
      Care UK,Health Care Providers & Services
      Carewatch Care Services Limited,Health Care Providers & Services
      Carey Group plc,Construction & Engineering
      Carey Olsen LLP,Professional Services
      Cargill,Food Products
      Carl Zeiss Microscopy Limited,Electrical Equipment
      Carlick Contract Furniture Limited,Household Durables
      Carlisle Brass Limited,Building Products
      Carlson Wagonlit Travel Inc,Hotels, Restaurants & Leisure
      Carnell,Construction & Engineering
      Carnival Corporation,Hotels, Restaurants & Leisure
      Carnival Corporation & plc,Hotels, Restaurants & Leisure
      Carpenter Corporation,Chemicals
      Carpmaels & Ransford,Professional Services
      Carr's Group plc,Industrial Conglomerates
      Carr'S Group Plc,Industrial Conglomerates
      Carter Jonas,Real Estate Management & Development
      Carter Thermal Industries,Electrical Equipment
      Cartus Corporation,Road & Rail
      Cashmores Metals Limited,Machinery
      Casio Electronics Co. Ltd,Electronic Equipment, Instruments & Components
      Castell Howell Foods Limited,Distributors
      Castleoak Care Partnerships Ltd,Real Estate Management & Development
      Castrol Limited,Chemicals
      Casual Dining Group Ltd,Hotels, Restaurants & Leisure
      Catalent Inc,Life Sciences Tools & Services
      Catalyst By Design Limited,Real Estate Management & Development
      Caterpillar,Construction & Engineering
      Cath Kidston Ltd,Specialty Retail
      Caunton Engineering Ltd,Construction & Engineering
      Cavanna Homes Group Limited,Household Durables
      CB&I Inc,Construction & Engineering
      CBRE Group Inc.,Real Estate Management & Development
      CCS Group Plc,Commercial Services & Supplies
      CCS Media Ltd,IT Services
      CDC Group plc,Capital Markets
      CDE Global Limited,Metals & Mining
      Cedar Rock Capital Limited,Capital Markets
      Celestica Inc,Electronic Equipment, Instruments & Components
      Celgene Limited,Pharmaceuticals
      Celsa (UK) Holdings Limited,Metals & Mining
      Celtic plc,Media
      CEMEX UK Operations Limited,Construction Materials
      Centerplate Europe Limited,Hotels, Restaurants & Leisure
      Central Garage (Uppingham) Limited (t/a Sycamore Harley-Davidson),Specialty Retail
      Centregreat Group,Construction & Engineering
      Centrica plc,Multi-Utilities
      Centura Group Ltd,Real Estate Management & Development
      Cepac Limited,Containers & Packaging
      cer Engineering,Construction & Engineering
      Certas Energy UK Ltd ,Oil, Gas & Consumable Fuels
      Ceva Group Plc,Air Freight & Logistics
      CFH Docmail Ltd,Software
      CG Power Systems Ireland Limited ,Electrical Equipment
      CGG Services UK Limited,Oil, Gas & Consumable Fuels
      CGI IT UK Limited,IT Services
      CGI IT UK Ltd,IT Services
      CH & Co Catering Group,Hotels, Restaurants & Leisure
      CH2M Hill,Construction & Engineering
      Cha Technologies Group PLC,Textiles, Apparel & Luxury Goods
      Chalcroft Limited,Construction & Engineering
      Chandlers (Farm Equipment) Ltd,Specialty Retail
      Channel Commercials plc,Specialty Retail
      Channel Four Television Corporation (Channel 4),Media
      Chapman Freeborn Holdings Ltd,Airlines
      Charles Kendall Group Limited,Distributors
      Charles Russell Speechlys,Professional Services
      Charles Stanley & Co. Limited,Capital Markets
      Charles Stanley Group PLC,Capital Markets
      Charles Taylor Managing Agency Ltd,Professional Services
      Charles Taylor plc,Insurance
      Charles Tyrwhitt Limited,Textiles, Apparel & Luxury Goods
      Charles Wells Ltd,Beverages
      Charles Wilson Engineers Ltd,Diversified Consumer Services
      Chas A Blatchford & Sons Ltd,Health Care Equipment & Supplies
      Chaucer Syndicates Limited,Insurance
      Cheetham Hill Construction Ltd,Construction & Engineering
      Chelmer Foods Limited,Food & Staples Retailing
      Chelmer Housing Partnership Limited,Real Estate Management & Development
      Chelmsford Star Co-operative Society Ltd,Food & Staples Retailing
      Chelsea FC plc,Media
      Chemoxy International Ltd,Chemicals
      Chemring Group plc,Aerospace & Defense
      Chesnara plc,Insurance
      Chesterfield Royal Hospitals NHS Foundation Trust,Health Care Providers & Services
      Chevron Corporation,Oil, Gas & Consumable Fuels
      Chevron Energy Limited ,Oil, Gas & Consumable Fuels
      Cheyne Capital Management (UK) Llp,Capital Markets
      Chichester College,Diversified Consumer Services
      Chiesi Limited,Pharmaceuticals
      Chime Group Holdings Limited,Media
      Chime Group Holdings Limited,Media
      China Navigation Company Ltd (The),Marine
      Chiquita Brands International Inc,Food Products
      Choice Care Group Limited,Health Care Providers & Services
      Christian Dior UK Limited,Specialty Retail
      Christie NHS Foundation Trust (The),Health Care Providers & Services
      Christie's International Plc,Diversified Consumer Services
      Chubb Fire & Security Ltd,Electronic Equipment, Instruments & Components
      Chugai Pharma Europe Limited ,Pharmaceuticals
      Churchill China (UK) Ltd,Household Durables
      Churchill Contract Services Group Holdings Ltd,Commercial Services & Supplies
      Churngold Construction Limited,Construction & Engineering
      Ciena Corporation,Communications Equipment
      Cineworld Cinemas Ltd,Media
      Cinven Partners LLP,Professional Services
      Circle Holdings PLC,Health Care Providers & Services
      Cirque Consulting Ltd,Diversified Consumer Services
      CIS Security Limited,Commercial Services & Supplies
      Citrix Systems,Electronic Equipment, Instruments & Components
      City and County Healthcare Group,Health Care Providers & Services
      City Football Group Limited,Media
      City Hospitals Sunderland NHS Foundation Trust,Health Care Providers & Services
      City Plumbing Supplies Holdings Limited,Trading Companies & Distributors
      City Refrigeration (UK) Holdings,Commercial Services & Supplies
      CityFleet Networks Limited,Road & Rail
      CitySprint (UK) Ltd,Commercial Services & Supplies
      Civica Group Limited,Software
      CLAAS UK Ltd,Trading Companies & Distributors
      Claire’s Stores,Specialty Retail
      Clarins (UK) Limited,Personal Products
      Clarion Housing Group Ltd,Real Estate Management & Development
      Clark Contracts Ltd,Construction & Engineering
      Clarke Energy Limited,Trading Companies & Distributors
      Clarke Telecom Limited,Construction & Engineering
      Clarke Willmott LLP,Professional Services
      Clarkson PLC,Marine
      Clean Linen Services Limited,Commercial Services & Supplies
      Cleansing Service Group Limited,Commercial Services & Supplies
      Clearsprings Ready Homes Ltd,Real Estate Management & Development
      Clearwater Group Ltd,Machinery
      Cleaver Fulton Rankin Ltd,Professional Services
      Click Travel Limited,Hotels, Restaurants & Leisure
      Clinigen Group plc,Life Sciences Tools & Services
      CliniMed (Holdings) Ltd,Health Care Equipment & Supplies
      CliniqueClinique Laboratories,Personal Products
      Clipfine Ltd,Household Durables
      Cloudreach,Internet Software & Services
      Clowes Developments (UK) Limited,Real Estate Management & Development
      CLS Holdings plc,Real Estate Management & Development
      Club La Costa (UK) plc,Hotels, Restaurants & Leisure
      Clugston Construction Ltd,Construction & Engineering
      Cluttons LLP,Real Estate Management & Development
      CLYDE & CO LLP,Professional Services
      Clydesdale Financial Services Limited,Diversified Financial Services
      CME Group Inc,Capital Markets
      CMS Cameron McKenna Nabarro Olswang LLP,Commercial Services & Supplies
      CNH Industrial N.V,Machinery
      CNOOC UK Limited,Oil, Gas & Consumable Fuels
      Co-operative Bank (The),Banks
      Co-operative Group Limited,Food Products
      Coast & Country Housing Limited,Real Estate Management & Development
      Coast Fashions LImited,Textiles, Apparel & Luxury Goods
      Coats Group plc,Textiles, Apparel & Luxury Goods
      COBA International Ltd,Building Products
      Cobell Ltd,Food & Staples Retailing
      Cobham Plc ,Aerospace & Defense
      Coca-Cola Company (The),Beverages
      Coca-Cola HBC AG,Beverages
      Cola HBC Northern Ireland Limited ,Beverages
      Cockett Marine Oil Limited,Oil, Gas & Consumable Fuels
      Cogeco Inc,Media
      Cognizant Worldwide Limited,IT Services
      Cohort plc,Aerospace & Defense
      Colas Rail Limited,Construction & Engineering
      Colchester Institute,Diversified Consumer Services
      Coleg Cambria,Diversified Consumer Services
      Colgate-Palmolive Company,Household Products
      Colliers International Property Advisers UK LLP,Real Estate Management & Development
      Collins Construction Ltd,Construction & Engineering
      Coloplast A/S,Health Care Equipment & Supplies
      Comau LLC,Machinery
      Commonwealth Bank of Australia,Banks
      Communisis plc,Commercial Services & Supplies
      Community Health Partnerships Limited,Diversified Financial Services
      Compagnie Financière Richemont SA,Textiles, Apparel & Luxury Goods
      Compagnie Fruitiere UK Limited ,Food Products
      Complete Business Solutions Group Limited,Internet Software & Services
      Compass Group plc,Hotels, Restaurants & Leisure
      Compco Fire Systems Limited,Commercial Services & Supplies
      Compello Staffing Group Limited,Professional Services
      Complete Coffee Limited,Beverages
      Computational Dynamics Limited,Software
      Computer Associates Holding Limited,Software
      Computer Sciences Corporation,IT Services
      Conamar Building Services Limited,Building Products
      ConceptLife Sciences Ltd,Life Sciences Tools & Services
      Concerto Group Limited,Media
      Conlon Construction Ltd,Construction & Engineering
      Connect Group PLC,Distributors
      Connells Limited,Real Estate Management & Development
      Conning Holdings Limited,Capital Markets
      ConocoPhillips (U.K.) Limited,Oil, Gas & Consumable Fuels
      Conran Holdings Limited,Commercial Services & Supplies
      Consort Medical plc,Health Care Equipment & Supplies
      Constantia Flexibles Holding GmbH,Containers & Packaging
      Constellation Brands,Beverages
      Constructions Industrielles de la Méditerranée,Commercial Services & Supplies
      Consumers Association (t/a Which?),Media
      Contact Recruitment,Professional Services
      Contechs Holdings Limited,Commercial Services & Supplies
      Continental Aktiengesellschaft,Auto Components
      Continental Tyre Group Ltd,Specialty Retail
      Continental Wine & Food Ltd,Distributors
      Control Risks Group Holdings Limited,Professional Services
      Convergence (Group  Networks) Limited,IT Services
      Conviviality Group Limited,Distributors
      Conviviality Plc,Food & Staples Retailing
      COOK Trading Ltd,Food Products
      Cooneen By Design Limited,Textiles, Apparel & Luxury Goods
      CooperVision Manufacturing Limited,Health Care Equipment & Supplies
      CoorsTek Inc,Chemicals
      Copart UK Limited,Internet Software & Services
      Cordant Group plc,Professional Services
      Core Assets Group Limited,Commercial Services & Supplies
      CORMAC,Real Estate Management & Development
      Cormar (Exports) Limited,Distributors
      Cornelius Group Plc,Distributors
      Cornerstone Telecommunications Infrastructure Limited,Wireless Telecommunication Services
      Corney & Barrow Ltd,Distributors
      Corning Incorporated,Electronic Equipment, Instruments & Components
      Corona Energy Limited,Gas Utilities
      Corps Of Commissionaires Management Limited,Commercial Services & Supplies
      Cory Riverside Energy Group,Independent Power and Renewable Electricity Producers
      Cosco Shipping (UK) Company Limited,Marine
      Cosmo Oil (UK) plc,Oil, Gas & Consumable Fuels
      Costain Group PLC,Construction & Engineering
      Cote Restaurants Group Holdings Ltd,Hotels, Restaurants & Leisure
      Cott Beverages Limited UK,Beverages
      Cotton Traders Limited,Textiles, Apparel & Luxury Goods
      Country Style Foods Ltd,Food Products
      Country Style Recycling,Commercial Services & Supplies
      Countryside Properties PLC,Household Durables
      Countrywide Care-Homes Ltd,Health Care Providers & Services
      Countrywide plc,Real Estate Management & Development
      County Durham and Darlington NHS Foundation Trust,Commercial Services & Supplies
      Cousins Group (Contractors) Ltd ,Professional Services
      Covéa Insurance Plc,Insurance
      Coveris UK Flexibles Ltd,Containers & Packaging
      Coyle Personnel Plc,Professional Services
      CP Foods (UK) Limited,Food Products
      CP Holdings Limited,Hotels, Restaurants & Leisure
      CPL Industries Group Limited,Oil, Gas & Consumable Fuels
      CPPGroup Plc,Commercial Services & Supplies
      CQS (UK) LLP,Capital Markets
      CRA International,Professional Services
      Craghoppers Ltd,Textiles, Apparel & Luxury Goods
      Craig Group Ltd,Marine
      Cranfield University,Diversified Consumer Services
      Cranswick PLC,Food Products
      Cray UK Ltd,Technology Hardware, Storage & Peripherals
      Creation Financial Services Limited,Consumer Finance
      Creative Distribution Limited,Electronic Equipment, Instruments & Components
      Creative Video Productions Limited,Distributors
      Credit Agricole S.A,Banks
      Credit Suisse Group AG,Capital Markets
      Creed Foodservice Ltd,Food Products
      Creo Pharmaceuticals Ltd,Pharmaceuticals
      Cressall Resistors Ltd,Electrical Equipment
      Crest Nicholson PLC,Household Durables
      Crest Plus Ltd,Professional Services
      Crew Clothing Company Limited,Specialty Retail
      CRH plc,Construction Materials
      CRISIL Limited ,Capital Markets
      Criteo Ltd,Internet Software & Services
      Croda International plc,Chemicals
      Cromwell Group (Holdings) Limited,Trading Companies & Distributors
      Cross Keys Homes Ltd,Real Estate Management & Development
      Cross Manufacturing Company (1938) Limited,Machinery
      Croudace Homes Group Limited,Household Durables
      Crowe Clark Whitehill LLP,Professional Services
      Crown Agents Ltd,Professional Services
      Crown Estate,Capital Markets
      Crown Lift Trucks Limited,Machinery
      Crown Oil Ltd,Oil, Gas & Consumable Fuels
      Crown Packaging Europe GmbH,Containers & Packaging
      Croydon Health Services NHS Trust,Health Care Providers & Services
      Cruden Group Ltd,Construction & Engineering
      Cruden Holdings Limited,Capital Markets
      Cruise & Maritime Voyages Ltd,Hotels, Restaurants & Leisure
      Crystal Cleaning Solutions Ltd,Commercial Services & Supplies
      CSL Behring UK Limited,Biotechnology
      CTI Travel Ltd,Hotels, Restaurants & Leisure
      Culina Group Limited,Air Freight & Logistics
      Cundall Johnston & Partners LLP,Construction & Engineering
      Currie & Brown Holdings Limited,Professional Services
      Cushman & Wakefield LLP,Professional Services
      CVC Capital Partners Limited,Capital Markets
      CYBG plc (Clydesdale Bank and Yorkshire Bank),Banks
      Cygnet Health Care Limited,Health Care Providers & Services
      Czarnikow Group Limited,Food & Staples Retailing
      D Young & Co LLP,Professional Services
      D-Link Corporation,Communications Equipment
      D.C. Thomson & Co. Ltd,Media
      Delifrance (UK) Ltd,Food & Staples Retailing
      Délifrance (UK) Ltd,Food & Staples Retailing
      DAC Beachcroft Claims Ltd,Professional Services
      DAC Beachcroft LLP,Professional Services
      Dachser Ltd,Air Freight & Logistics
      DAI Global LLC,Real Estate Management & Development
      Daikin Airconditioning UK Ltd,Trading Companies & Distributors
      Daikin Chemical Europe GmbH,Chemicals
      Daimler Holdings UK LTD,Automobiles
      Dairy Crest Group plc,Food Products
      Daiwa Capital Markets Europe Limited,Capital Markets
      Dalziel Limited,Food & Staples Retailing
      Damartex (UK) Limited,Internet & Direct Marketing Retail
      Dana Petroleum,Oil, Gas & Consumable Fuels
      Danaher Corporation,Health Care Equipment & Supplies
      Danbro Group,Professional Services
      Daniel Owen Ltd,Professional Services
      Daniel Thwaites plc,Hotels, Restaurants & Leisure
      Danish Crown UK Ltd,Food Products
      Danwood Group Ltd,IT Services
      Dart Group plc,Airlines
      DAS UK Holdings Limited,Insurance
      Dassault Systèmes S.E,Software
      David Cover & Sons Ltd,Trading Companies & Distributors
      David's Bridal UK Limited,Specialty Retail
      Davidsons Developments Limited,Real Estate Management & Development
      Dawnfresh Seafoods Ltd,Food Products
      Dawnus Construction Holdings Ltd ,Construction & Engineering
      Dawsonrentals Truck & Trailer Ltd,Road & Rail
      Day Group Ltd,Construction Materials
      Day Lewis plc,Food & Staples Retailing
      DB Cargo (UK) Limited,Road & Rail
      DBS Bank Ltd,Banks
      DCC plc,Industrial Conglomerates
      DCC Vital Ltd,Health Care Providers & Services
      De Beers plc,Metals & Mining
      De La Rue plc,Commercial Services & Supplies
      De Lage Landen Leasing Limited (DLL),Diversified Financial Services
      De Montfort University,Diversified Consumer Services
      de Poel UK Limited,Professional Services
      Dealogic Limited,Internet Software & Services
      Debenhams Retail plc,Multiline Retail
      Debevoise & Plimpton LLP,Professional Services
      Dechert LLP,Professional Services
      Dechra Pharmaceuticals PLC,Pharmaceuticals
      Deeley Group Limited,Real Estate Management & Development
      DeepOcean Group Holding B.V,Construction & Engineering
      Dell Inc,Technology Hardware, Storage & Peripherals
      Deloitte LLP,Professional Services
      Delta Group,Commercial Services & Supplies
      Denby Holdings Limited,Household Durables
      Denholm Oilfield Services Limited,Energy Equipment & Services
      Denholm Oilfield Services Limited,Energy Equipment & Services
      Dennis & Robinson Limited (t/a Paula Rosa Manhattan),Household Durables
      Dennis Eagle Limited,Machinery
      Dentons UKMEA LLP,Professional Services
      Dentsply International Inc,Health Care Equipment & Supplies
      Dentsu Aegis London Limited ,Media
      Derby Teaching Hospitals NHS Foundation Trust,Health Care Providers & Services
      Derwent London plc,Equity Real Estate Investment Trusts (REITs)
      Desire2Learn Incorporated (D2L),Internet Software & Services
      Desk Top Publishing Microsystems Ltd (t/a DTP Group),Commercial Services & Supplies
      Deutsche Bahn Group ,Road & Rail
      Deutsche Bank AG ,Capital Markets
      Devro plc,Food Products
      DF Concerts Limited,Hotels, Restaurants & Leisure
      DF Concerts Limited,Media
      DFDS A/S,Marine
      DFS Furniture plc,Household Durables
      DHL International UK,Air Freight & Logistics
      Diageo plc,Beverages
      Dialight plc,Electrical Equipment
      Dialog Semiconductor plc,Semiconductors & Semiconductor Equipment
      DiaSorin S.p.A,Health Care Equipment & Supplies
      Dick Lovett Limited,Specialty Retail
      Dickson Minto W.S,Professional Services
      Diebold Inc,Technology Hardware, Storage & Peripherals
      Dignity plc,Diversified Consumer Services
      Dimensional Fund Advisors Ltd,Capital Markets
      Diploma PLC,Trading Companies & Distributors
      Direct Line Insurance Group plc,Insurance
      Direct Rail Services Limited,Road & Rail
      Discoverie Group Plc,Electrical Equipment
      Discovery Communications,Media
      Distinction Doors Limited,Trading Companies & Distributors
      Distrupol Limited,Trading Companies & Distributors
      Dixons Carphone plc,Specialty Retail
      DLA Piper International LLP,Professional Services
      DLF Seeds Ltd,Food Products
      DMGT (Daily Mail and General Trust plc),Media
      dnata,Transportation Infrastructure
      DNV GL AS,Professional Services
      Dobbies Garden Centres Limited,Specialty Retail
      Doctors Laboratory Ltd (The),Health Care Providers & Services
      Dodd Group Holdings Limited,Construction & Engineering
      Dodson & Horrell Ltd,Food Products
      DOF ASA,Marine
      Dollar Financial UK Limited,Consumer Finance
      Domestic & General Group Limited,Insurance
      Domino Printing Sciences plc,Electronic Equipment, Instruments & Components
      Domino’s Pizza Group plc,Hotels, Restaurants & Leisure
      Donalds Group (The),Specialty Retail
      Doncasters Group Ltd,Aerospace & Defense
      DONG E&P (UK) Limited,Oil, Gas & Consumable Fuels
      DONG Energy Power Sales UK Limited,Oil, Gas & Consumable Fuels
      DONG Energy Salg & Service A/S,Multi-Utilities
      DONG Energy West of Duddon Sands (UK) Limited,Independent Power and Renewable Electricity Producers
      DONG Energy Westermost Rough Limited,Independent Power and Renewable Electricity Producers
      DONG Energy Wind Power A/S,Independent Power and Renewable Electricity Producers
      Donnelley Financial Solutions ,Capital Markets
      Dorling Kindersley Limited,Media
      dormakaba Holding AG,Building Products
      Dormole Limited,Trading Companies & Distributors
      Dorrington Plc,Real Estate Management & Development
      Dow Agrosciences Limited,Chemicals
      Dow Europe GmbH,Chemicals
      DP World Ltd,Transportation Infrastructure
      DPDgroup UK Ltd,Air Freight & Logistics
      Draeger UK & Ireland,Health Care Equipment & Supplies
      Dragon LNG Limited,Oil, Gas & Consumable Fuels
      DrainsAid,Commercial Services & Supplies
      Draper Tools Limited,Trading Companies & Distributors
      Drax Group plc,Independent Power and Renewable Electricity Producers
      DriveForce Limited,Professional Services
      Drum Cussac Group Limited,Professional Services
      DS Smith plc,Containers & Packaging
      DSM Demolition Limited,Construction & Engineering
      DSV A/S,Road & Rail
      Dun & Bradstreet Limited,Professional Services
      Dunbia Ltd,Food Products
      Dunelm Group plc,Specialty Retail
      Dunhills (Pontefract) plc (t/a Haribo),Food Products
      dunnhumby Limited,Media
      DuPont U.K. Ltd,Electrical Equipment
      Durbin plc,Health Care Equipment & Supplies
      DWF LLP,Professional Services
      Dwr Cymru Welsh Water,Water Utilities
      DX (Group) plc,Air Freight & Logistics
      Dyer & Butler Ltd,Construction & Engineering
      Dyson Limited,Household Durables
      E .P. Barrus Ltd,Trading Companies & Distributors
      E. G. Carter & Co Ltd,Household Durables
      E.G.L. Homecare Ltd,Household Products
      E.J. Taylor & Sons Limited,Construction & Engineering
      E.ON SE,Electric Utilities
      E.ON SE,Electric Utilities
      E.W. Beard Ltd ,Construction & Engineering
      e2v technologies plc,Electronic Equipment, Instruments & Components
      Eakin Group,Health Care Equipment & Supplies
      East Lancashire Hospitals NHS Trust ,Health Care Providers & Services
      East Leicestershire and Rutland Clinical Commissioning Group,Health Care Providers & Services
      East Thames Group Limited,Real Estate Management & Development
      Eastman Chemical Company,Chemicals
      easyJet plc,Airlines
      EAT Ltd,Hotels, Restaurants & Leisure
      Eaton Corporation plc,Electrical Equipment
      eBECS Ltd,Software
      Ebiquity plc,Media
      ebm-papst UK Ltd,Machinery
      ECM (Vehicle Delivery Service) Ltd,Diversified Consumer Services
      ECO Animal Health Group Plc,Pharmaceuticals
      Economist Group Ltd (The),Media
      Economist Newspaper Limited (The),Media
      Ecotricity,Independent Power and Renewable Electricity Producers
      Ed Broking Group Ltd ,Insurance
      ED&F Man Group,Food & Staples Retailing
      Eddie Bauer,Textiles, Apparel & Luxury Goods
      Eden Springs UK Limited,Machinery
      EDF Energy Holdings Limited,Multi-Utilities
      EDF Trading Ltd,Multi-Utilities
      Edge Hill University,Diversified Consumer Services
      Edgen Murray Corporation,Trading Companies & Distributors
      Edinburgh Napier University,Diversified Consumer Services
      EDM Group Ltd,Internet Software & Services
      Edmundson Electrical Limited,Trading Companies & Distributors
      Edrington Group Limited,Beverages
      EE Ltd,Wireless Telecommunication Services
      Efficio Limited,Professional Services
      egetæpper a/s,Household Durables
      EGGER Group,Building Products
      Egmont Group,Media
      Ei Group plc,Hotels, Restaurants & Leisure
      Eisai Europe Limited,Health Care Providers & Services
      Eisai Europe Limited,Health Care Providers & Services
      Elan Homes Holdings Ltd,Household Durables
      Electricity North West,Electric Utilities
      Electricity North West Limited,Electric Utilities
      Electricity Supply Board ,Electric Utilities
      Electrium Sales Limited,Electronic Equipment, Instruments & Components
      Electrocomponents plc,Electronic Equipment, Instruments & Components
      Electroimpact Inc.,Aerospace & Defense
      Elektron Technology plc,Electrical Equipment
      Elementis PLC,Chemicals
      Eli Lilly and Company Limited,Pharmaceuticals
      Elior UK,Hotels, Restaurants & Leisure
      Elizabeth Arden (UK) Ltd,Personal Products
      Elkem AS,Metals & Mining
      Elliott Baxter & Company Limited,Trading Companies & Distributors
      Elliott Group Limited,Commercial Services & Supplies
      Ellucian Inc,Software
      EMC Corp,Technology Hardware, Storage & Peripherals
      EMCOR UK Ltd,Construction & Engineering
      Emerald Group Holdings Limited (t/a Emerald Publishing Limited),Media
      Emergya Wind Technologies U.K. Ltd,Independent Power and Renewable Electricity Producers
      Emerson Electric Co,Electrical Equipment
      Emmett UK Ltd,Food Products
      Emmi AG,Food Products
      Emo DCC Energy Ltd,Oil, Gas & Consumable Fuels
      Empresaria Group plc,Professional Services
      Emprise Services plc,Commercial Services & Supplies
      En Route International Limited,Food Products
      Encirc Limited,Containers & Packaging
      Encon Insulation Ltd,Trading Companies & Distributors
      Encore Personnel Services Ltd,Professional Services
      Endava Ltd,IT Services
      Energetics Networked Energy Limited,Construction & Engineering
      Energizer Holdings Inc,Household Products
      Engenda Group Limited,Construction & Engineering
      ENGIE Services Holding UK Limited,Electric Utilities
      Engine Holding LLC ,Media
      Enotria Winecellars Limited,Distributors
      EnQuest plc,Oil, Gas & Consumable Fuels
      Enra Group Ltd,Diversified Financial Services
      EnServe Group Limited,Construction & Engineering
      Enterprise Rent-A-Car UK Limited,Road & Rail
      Entertainment One Ltd (eOne),Media
      EnTrustPermal Ltd,Capital Markets
      Environmental Resources Management (ERM) Worldwide Group Ltd,Commercial Services & Supplies
      EnviroVent Limited,Electrical Equipment
      Epson (UK) Limited,Electronic Equipment, Instruments & Components
      Epwin Group Plc,Building Products
      EQT Partners UK Advisors LLP,Capital Markets
      equensWorldline SE,IT Services
      Equine and Livestock Insurance Company,Insurance
      Equip Outdoor Technologies UK Ltd,Distributors
      Equitix Holdings Limited,Capital Markets
      Eric Wright Group Ltd,Construction & Engineering
      Ericsson,Communications Equipment
      ERM Worldwide Group Ltd,Professional Services
      Ernst & Young LLP,Professional Services
      ESI Media,Media
      ESM Power,Electric Utilities
      Esri UK,Software
      Essar Oil (UK) Ltd,Oil, Gas & Consumable Fuels
      Essentra plc,Chemicals
      Essex Services Group Plc,Electrical Equipment
      Esso UK Limited,Oil, Gas & Consumable Fuels
      Estate Technical Solutions Limited (t/a ETSOS),Internet Software & Services
      Estee Lauder Cosmetics Limited,Personal Products
      esure Group  plc,Insurance
      etc.venues Ltd,Real Estate Management & Development
      Etex Building Performance Ltd,Building Products
      ETrawler Unlimited Company,Internet & Direct Marketing Retail
      Euler Hermes UK Plc,Insurance
      euNetworks,Internet Software & Services
      Euro Car Parts Limited,Distributors
      Euro Food Brands Limited,Food Products
      Euro Packaging UK Limited,Containers & Packaging
      Eurocell plc,Building Products
      Euroclear SA/NV,Capital Markets
      Eurofins Scientific SE,Life Sciences Tools & Services
      Euromoney Institutional Investor PLC,Media
      Euromonitor International Ltd,Media
      Euromonitor International Ltd,Media
      Europcar UK Limited,Road & Rail
      Europe Arab Bank plc,Banks
      European Electronique,IT Services
      European Oat Millers Ltd,Food Products
      Eurostar International Limited,Road & Rail
      Everest Ltd,Commercial Services & Supplies
      Everest Ltd,Household Durables
      Eversheds Sutherland LLP,Professional Services
      Eversholt Rail Group Ltd,Trading Companies & Distributors
      Everton Football Club,Media
      Everyday Lending Limited,Consumer Finance
      Evesons Fuels Ltd,Oil, Gas & Consumable Fuels
      EVO Group (t/a EVO Business Supplies Limited),Commercial Services & Supplies
      Evo Services Ltd,Professional Services
      EvoBus (UK) Ltd,Distributors
      Evolution Homecare Services Ltd,Health Care Providers & Services
      Evonik Industries AG,Chemicals
      Evoqua Water Technologies LLC,Machinery
      EVRAZ plc,Metals & Mining
      Evron Foods Limited,Food Products
      EVS Broadcast Equipment SA,Communications Equipment
      Exemplar Health Care Ltd,Health Care Providers & Services
      Exertis (UK) Ltd,Electronic Equipment, Instruments & Components
      Exertis Supply Chain Services Ltd,Air Freight & Logistics
      Exova Group plc,Professional Services
      Expense Reduction Analysts UK Ltd,Professional Services
      Experian Limited,Professional Services
      Experian plc,Professional Services
      Experis Limited,Professional Services
      Explore Worldwide Limited,Hotels, Restaurants & Leisure
      Exponential-e Ltd,IT Services
      Export -Import Bank of India,Banks
      Express Gifts Limited,Internet & Direct Marketing Retail
      Express Reinforcements Limited,Metals & Mining
      Exxonmobil Marine Limited,Oil, Gas & Consumable Fuels
      F.C. Brown (Steel Equipment) Limited,Commercial Services & Supplies
      F.Hinds Limited,Specialty Retail
      F.M. Conway  Ltd,Construction & Engineering
      F.W. Baker Group Ltd,Food Products
      F&C Management Limited,Capital Markets
      Faccenda Foods Limited,Food Products
      Fairfax Meadow Ltd,Distributors
      Fairpoint Group Plc,Diversified Consumer Services
      Falck Renewables S.p.A,Independent Power and Renewable Electricity Producers
      Falmouth University,Diversified Consumer Services
      Faraday Underwriting Limited,Insurance
      Farmfoods Ltd,Food & Staples Retailing
      Farrer & Co LLP,Professional Services
      Farrow & Ball Ltd,Chemicals
      Fast Retailing Co,Specialty Retail
      Faster Payments Scheme Limited,Commercial Services & Supplies
      Fasthosts Internet Limited,Internet Software & Services
      FastTrack Management Services Ltd,Professional Services
      FatFace Ltd,Specialty Retail
      FCE Bank Plc,Consumer Finance
      FDM Group (Holdings) PLC,IT Services
      Federal-Mogul Limited,Auto Components
      FedEx Corp,Air Freight & Logistics
      FedEx UK Limited,Air Freight & Logistics
      Fellowes,Commercial Services & Supplies
      Feltham Group Ltd,Household Durables
      Fengrain Limited,Commercial Services & Supplies
      Fenner plc,Machinery
      Ferguson plc ,Trading Companies & Distributors
      Ferraris Piston Service Limited,Specialty Retail
      Ferrero UK Limited,Food Products
      Ferrexpo plc,Metals & Mining
      Ferring Pharmaceuticals Limited,Pharmaceuticals
      Fiat Chrysler Automobiles N.V,Automobiles
      Fiat Chrysler Automobiles UK Ltd,Specialty Retail
      FibreFab Ltd,Communications Equipment
      Fidelity National Information Services,IT Services
      Fidessa plc,Software
      Fieldfisher LLP,Professional Services
      Fife College,Diversified Consumer Services
      FIL Holdings (UK) Limited,Capital Markets
      Financial Ombudsman Service (The),Professional Services
      Financial Times Ltd (The),Media
      FinancialForce UK Limited,Internet Software & Services
      Finastra Group Holdings Limited,Software
      Finastra International Limited,Software
      Findel Plc,Internet & Direct Marketing Retail
      Findlay Park Partners LLP,Capital Markets
      Fine Foods International (Manufacturing) Ltd,Beverages
      Finlays,Food Products
      Finning UK Limited,Trading Companies & Distributors
      Finsbury Food Group Plc,Food Products
      Fircroft Engineering Service Limited,Professional Services
      First Ark Limited,Diversified Consumer Services
      First Choice Homes Oldham Ltd,Real Estate Management & Development
      First Data Corporation,IT Services
      First Derivatives plc,IT Services
      First Personnel Ltd,Professional Services
      First Rate Exchange Services Limited,Consumer Finance
      FirstGroup plc,Road & Rail
      Fish Brothers (Swindon) Limited,Specialty Retail
      Fitch Ratings Ltd,Capital Markets
      FitFlop Limited,Textiles, Apparel & Luxury Goods
      Flair Leisure Products plc,Distributors
      Flakt Woods Limited,Machinery
      Flamstead Holdings Limited,Chemicals
      FleetCor Technologies ,IT Services
      Flexforce,Professional Services
      Flint Ink (U.K.) Limited,Chemicals
      Flogas Britain Ltd,Oil, Gas & Consumable Fuels
      FloPlast Limited,Building Products
      Florette UK & Ireland Ltd,Food Products
      Flowgroup Plc,Electrical Equipment
      Flowserve Corporation,Machinery
      FLSmidth A/S,Machinery
      Fluor Corporation,Construction & Engineering
      Flybe Group PLC,Airlines
      Flynn Pharma Limited,Health Care Providers & Services
      Foot Anstey LLP,Professional Services
      Footasylum Ltd,Specialty Retail
      Footasylum Ltd,Specialty Retail
      Football Association Premier League Limited (The),Media
      Ford Fuels Limited,Specialty Retail
      Ford Motor Company Limited,Automobiles
      Ford Retail Ltd,Specialty Retail
      Foresight Group LLP,Capital Markets
      Foresight Recruitment Services Ltd,Professional Services
      ForFarmers UK Limited,Food Products
      Forgefix Limited,Trading Companies & Distributors
      Formica Limited,Paper & Forest Products
      Formula One Autocentres Limited,Specialty Retail
      Forrest,Construction & Engineering
      Forsters LLP,Professional Services
      Foster + Partners Ltd,Professional Services
      Fostering Solutions Limited,Commercial Services & Supplies
      Four Seasons Health Care Limited,Health Care Providers & Services
      Fourfront Group Limited,Capital Markets
      Fowler Welch Coolchain Ltd,Road & Rail
      Foxtons Group PLC,Real Estate Management & Development
      Foyle Food Group Limited,Food Products
      FP McCann Limited,Construction Materials
      Fraikin Limited,Commercial Services & Supplies
      Francis Crick Institute (The),Professional Services
      Frank Recruitment Group Limited,Professional Services
      Franklin Templeton Investment Management Limited,Capital Markets
      Frazer-Nash Consultancy Limited,Construction & Engineering
      Fred Perry Ltd,Textiles, Apparel & Luxury Goods
      Fred. Olsen Cruise Lines Limited,Hotels, Restaurants & Leisure
      Fred. Olsen Limited,Industrial Conglomerates
      Frederic Robinson Ltd,Beverages
      Freedom Leisure,Hotels, Restaurants & Leisure
      Freefoam Plastics UK Limited,Construction & Engineering
      Freeman,Media
      Freeport-McMoRan Inc,Metals & Mining
      Freeths LLP,Professional Services
      Freight Transport Association,Air Freight & Logistics
      Freightliner Group Limited,Road & Rail
      French Connection Group Plc,Specialty Retail
      Fresenius Kabi Ltd,Pharmaceuticals
      Fresenius Medical Care (UK) Ltd,Health Care Providers & Services
      Fresh Direct Group Ltd,Food & Staples Retailing
      Freshfields Bruckhaus Derringer,Professional Services
      Freshtime UK Ltd,Food Products
      Fresnillo plc,Metals & Mining
      Frimley Trust NHS Foundation Trust,Health Care Providers & Services
      Froneri Ltd,Food Products
      Frontline Ltd,Oil, Gas & Consumable Fuels
      FTI Consulting LLP,Professional Services
      Fuchs Lubricants (UK) Limited,Chemicals
      Fuel Card Services Ltd,Oil, Gas & Consumable Fuels
      FUJIFILM DIMATIX,Technology Hardware, Storage & Peripherals
      FUJIFILM Diosynth Biotechnologies UK Limited ,Life Sciences Tools & Services
      FUJIFILM SonoSite,Health Care Equipment & Supplies
      Fujitsu Ltd,IT Services
      Fulcrum Group,Gas Utilities
      Funding Circle Limited,IT Services
      Furniture Village Limited,Specialty Retail
      Futures Housing Group,Household Durables
      Fyffes Group Ltd ,Food & Staples Retailing
      G F Tomlinson Group,Construction & Engineering
      G-Staff Ltd,Commercial Services & Supplies
      G4S plc,Commercial Services & Supplies
      Galldris Construction Limited,Household Durables
      Gallup,Professional Services
      Galmarley Limited (t/a BullionVault Ltd),Capital Markets
      Gama Aviation Plc,Airlines
      GAME Digital plc,Specialty Retail
      Games Workshop Group PLC,Leisure Products
      Gamesys,Restaurants & Leisure
      Gamma Communications plc,Diversified Telecommunication Services
      GANT AB,Distributors
      GAP Group Limited,Trading Companies & Distributors
      Gap Inc,Specialty Retail
      Gap Personnel Group,Professional Services
      Gardiner & Theobald LLP,Professional Services
      Gardline Shipping Limited,Transportation Infrastructure
      Gardman Ltd,Specialty Retail
      Gardner Denver Inc,Building Products
      Gartner U.K. Limited,Professional Services
      Gateley (Holdings) Plc,Professional Services
      GatenbySanderson Ltd,Professional Services
      Gates Corporation,Machinery
      Gattaca plc,Professional Services
      Gatwick Airport,Transportation Infrastructure
      Gazeley Holdings UK Limited,Construction & Engineering
      Gazprom Marketing & Trading Limited,Oil, Gas & Consumable Fuels
      GB Group plc,Software
      GB Railfreight Limited,Road & Rail
      GBG International Holding Company Ltd,Textiles, Apparel & Luxury Goods
      GBM Digital Technologies Ltd,Specialty Retail
      GBUK Group Ltd,Health Care Providers & Services
      GC Aesthetics plc,Health Care Equipment & Supplies
      GDC Group Ltd,Machinery
      Gear4Music Limited,Internet & Direct Marketing Retail
      Geberit Sales Ltd,Household Durables
      Gemfields plc,Metals & Mining
      GENBAND Inc,Software
      General All-Purpose Plastics Ltd,Building Products
      General Mills Inc,Food Products
      General Motors UK Ltd (t/a Vauxhall Motors),Automobiles
      Generation Investment Management LLP,Capital Markets
      Genesis Asset Managers Limited,Capital Markets
      Geo-Environmental Services Limited,Commercial Services & Supplies
      Geronimo Inns Limited,Hotels, Restaurants & Leisure
      Getech Limited,Distributors
      Getinge Group,Health Care Providers & Services
      Getty Images,Media
      Gi Group Recruitment Ltd,Professional Services
      Giesecke & Devrient GmbH,Electronic Equipment, Instruments & Components
      Gilbert-Ash Limited,Construction & Engineering
      Givenchy SA,Textiles, Apparel & Luxury Goods
      GKN plc,Auto Components
      Gladman Developments Limited,Real Estate Management & Development
      Glasgow Caledonian University,Diversified Consumer Services
      GlaxoSmithKline plc,Pharmaceuticals
      Gleadell & Dunns,Food & Staples Retailing
      Glen Raven,Textiles, Apparel & Luxury Goods
      Glenair UK Limited,Electrical Equipment
      Glencore plc,Metals & Mining
      Glendale Managed Services Limited,Commercial Services & Supplies
      GLH Hotels Ltd,Hotels, Restaurants & Leisure
      Glinwell Marketing Ltd,Food & Staples Retailing
      Global Invacom Group Ltd,Diversified Consumer Services
      Global Navigation Solutions Limited,Software
      Glory Global Solutions (International) Limited,Technology Hardware, Storage & Peripherals
      Glynwed Pipe Systems Limited (t/a Durapipe UK),Building Products
      GMI Construction Group plc,Construction & Engineering
      Go Plant Ltd,Building Products
      Go Plant Ltd,Trading Companies & Distributors
      Go-Ahead Group plc,Road & Rail
      Gocompare.com Group plc,Internet Software & Services
      Gold Medal Travel Group plc,Hotels, Restaurants & Leisure
      Goldman Sachs Group Inc. (The),Capital Markets
      Goldsmiths,Diversified Consumer Services
      Gooch & Housego plc,Electronic Equipment, Instruments & Components
      Good Energy Ltd,Independent Power and Renewable Electricity Producers
      Goodman Real Estate (UK) Limited,Real Estate Management & Development
      Goodwin International Limited,Machinery
      Goodwin Plc,Machinery
      Goodwood Estate Company Limited,Hotels, Restaurants & Leisure
      Gordon Ramsay Restaurant Group,Hotels, Restaurants & Leisure
      Gowling WLG (UK) LLP,Professional Services
      GPS Food Group (UK) Ltd,Food & Staples Retailing
      GPSM DiveCo Ltd,Construction & Engineering
      Gradus Limited,Building Products
      Graff Diamonds International Limited,Textiles, Apparel & Luxury Goods
      Grafton Group PLC,Trading Companies & Distributors
      Grafton Recruitment Limited,Professional Services
      Graham,Machinery
      Graham & Brown Limited,Household Durables
      Grainger plc,Real Estate Management & Development
      Grand Union Housing Group,Household Durables
      Grande Cheese Company Inc,Food Products
      Grant & Stone Limited,Commercial Services & Supplies
      Grant Thornton International Ltd,Professional Services
      Graphic Packaging International Bardon Limited,Containers & Packaging
      Graphic Packaging International Inc,Containers & Packaging
      Gratte Brothers Group Ltd,Construction & Engineering
      Gravity Media Group Limited,Commercial Services & Supplies
      Great Portland Estates plc,Equity Real Estate Investment Trusts (REITs)
      Great Yarmouth and Waveney Clinical Commissioning Group,Health Care Providers & Services
      Greater Manchester West Mental Health NHS Foundation Trust,Health Care Providers & Services
      Greencell Ltd,Food & Staples Retailing
      Greene King plc,Hotels, Restaurants & Leisure
      Greggs plc,Hotels, Restaurants & Leisure
      Gregory Distribution Ltd,Road & Rail
      Greif UK Ltd,Containers & Packaging
      Grimsby Institute Group Corporation,Diversified Consumer Services
      Grosvenor Group Limited,Capital Markets
      Ground Control Limited,Commercial Services & Supplies
      Groupe Eurotunnel SE,Road & Rail
      Groupon,Internet & Direct Marketing Retail
      Gruma Europe Limited,Food Products
      Grundon Waste Management Limited,Commercial Services & Supplies
      Gs Yuasa Battery Europe Limited,Electrical Equipment
      GSM Association,Commercial Services & Supplies
      Guinness Partnership Ltd (The),Household Durables
      Gulf International Bank (UK) Limited,Capital Markets
      Gulf Marine Services PLC (GMS),Energy Equipment & Services
      GulfMark Offshore,Energy Equipment & Services
      Gullivers Truck Hire Ltd,Road & Rail
      Gurit Holding AG,Chemicals
      Guy’s and St Thomas’ NHS Foundation Trust,Health Care Providers & Services
      Gym Group plc (The),Health Care Providers & Services
      H I Weldrick Ltd,Food & Staples Retailing
      H. Young Holdings plc,Distributors
      H.B. Fuller Company,Chemicals
      H.C. Starck GmbH,Metals & Mining
      H.J. Banks & Company Ltd,Real Estate Management & Development
      H&M Group,Specialty Retail
      Habour & Jones Ltd,Hotels, Restaurants & Leisure
      Hachette UK Ltd,Media
      Hackett Limited,Textiles, Apparel & Luxury Goods
      Hafele U.K. Ltd,Trading Companies & Distributors
      Hager UK Ltd,Electronic Equipment, Instruments & Components
      Hain Daniels Group Limited,Food Products
      Hakkasan Limited,Hotels, Restaurants & Leisure
      Halewood International Ltd,Beverages
      Halfords Group plc,Specialty Retail
      Hall & Woodhouse Limited,Beverages
      Halliburton Manufacturing and Services Limited,Machinery
      Halma plc,Electronic Equipment, Instruments & Components
      Hammerson plc,Real Estate Management & Development
      Hampshire Hospitals NHS Foundation Trust,Health Care Providers & Services
      Hand Picked Hotels Limited,Hotels, Restaurants & Leisure
      Handicare AS,Health Care Providers & Services
      Hanson Quarry Products Europe Limited,Construction Materials
      Hanson UK Group,Construction Materials
      Hansteen Holdings PLC,Equity Real Estate Investment Trusts (REITs)
      Hanwa Co,Trading Companies & Distributors
      Hapimag AG,Hotels, Restaurants & Leisure
      Hard Rock Cafe International (USA),Hotels, Restaurants & Leisure
      Hargreaves Lansdown plc,Capital Markets
      Hargreaves Services Group,Oil, Gas & Consumable Fuels
      Harley-Davidson Europe Ltd,Specialty Retail
      Harman International,Household Durables
      Harper Adams University,Diversified Consumer Services
      Harper Macleod LLP,Professional Services
      Harpers Home Mix Ltd,Food Products
      Harrison & Clough Ltd,Trading Companies & Distributors
      Harrods Limited,Multiline Retail
      Harron Homes Limited,Real Estate Management & Development
      Harry Fairclough Group Ltd,Construction & Engineering
      Harsco Metals Group Limited,Metals & Mining
      Harting Technology Group,Electrical Equipment
      Hartwell Group PLC ,Specialty Retail
      Harvey Nichols Group Ltd,Specialty Retail
      Hasbro Inc,Leisure Products
      HaskoningDHV UK Ltd,Construction & Engineering
      Hastings Group Holdings PLC,Insurance
      Havelock Europa Plc,Construction & Engineering
      Hawk Group Limited,Trading Companies & Distributors
      Hawker Siddeley Switchgear Ltd,Electrical Equipment
      Hawkes Bay Holdings Ltd,Diversified Financial Services
      Hawthorn Estates Limited,Real Estate Management & Development
      Hayfin Capital Management LLP,Diversified Financial Services
      Haymarket Media Group,Media
      Haynes International,Metals & Mining
      Hays plc,Professional Services
      HB Reavis Construction UK Ltd ,Construction & Engineering
      HCA Healthcare UK,Health Care Providers & Services
      HCT Group,Road & Rail
      Headlam Group plc,Distributors
      HEADS Recruitment Ltd,Professional Services
      Healthcare at Home Ltd ,Health Care Providers & Services
      Healthcare Homes Group Limited,Health Care Providers & Services
      Heart of England Co-operative Society Ltd,Food & Staples Retailing
      Heathrow Airport Holdings Limited,Transportation Infrastructure
      Heathrow Truck Centre Ltd,Specialty Retail
      Heidelberg Graphic Equipment Limited,Trading Companies & Distributors
      Heineken UK Limited,Beverages
      Helical plc,Real Estate Management & Development
      HELLER Machine Tools Ltd,Machinery
      HelloFresh,Food & Staples Retailing
      Hemmersbach GmbH & Co. KG,Diversified Telecommunication Services
      Henderson Wholesale Limited,Commercial Services & Supplies
      Hendy Group Ltd,Specialty Retail
      Henry Boot plc,Household Durables
      Henry Schein UK Holdings Limited,Health Care Providers & Services
      Herbalife International Inc,Personal Products
      Herbert Smith Freehills LLP,Professional Services
      Herbert Smith Freehills LLP,Professional Services
      Heriot-Watt University,Diversified Consumer Services
      Hermes Fund Managers Limited,Diversified Financial Services
      Hewden Stuart Limited (Company),Trading Companies & Distributors
      Hewlett Packard Enterprise Company,Technology Hardware, Storage & Peripherals
      Hexadex Limited,Auto Components
      HgCapital,Capital Markets
      HH Global Limited,Media
      HHGL Limited (t/a Homebase and Bunnings),Specialty Retail
      Hibu Group Limited,Media
      Hickman Industries Limited,Building Products
      HICL Infrastructure Company Limited,Capital Markets
      Higgins Group PLC,Diversified Financial Services
      Highclere International Investors LLP ,Capital Markets
      Highland Spring Limited,Beverages
      Hill & Smith Holdings PLC,Metals & Mining
      Hill Dickinson LLP,Professional Services
      Hillarys,Household Durables
      Hills Group Limited (The),Commercial Services & Supplies
      Hills Prospect plc,Beverages
      Hilti (GB) Limited,Machinery
      Hilton Worldwide,Hotels, Restaurants & Leisure
      Hire Station (part of Vp plc),Trading Companies & Distributors
      Hitachi Capital (UK) PLC,Diversified Financial Services
      Hitachi Construction Machinery (UK) Ltd,Trading Companies & Distributors
      Hitachi Consulting UK Limited,Professional Services
      Hitachi Euope Limited,Industrial Conglomerates
      Hitachi Ltd,Electronic Equipment, Instruments & Components
      Hitachi Rail Europe Limited,Machinery
      Hoare Lea LLP,Professional Services
      Hochtief (UK) Construction Limited,Construction & Engineering
      Hogan Lovells International LLP,Professional Servces
      Hogarth Worldwide Limited,Media
      Hogg Robinson Group plc,Professional Services
      Holdsworth Foods,Food & Staples Retailing
      Holidaybreak Ltd,Hotels, Restaurants & Leisure
      Holman Fenwick Willan LLP,Professional Services
      Holroyd Howe Ltd,Hotels, Restaurants & Leisure
      Holt JCB Ltd,Specialty Retail
      Home Group Limited,Real Estate Management & Development
      Homebase Limited,Specialty Retail
      HoMedics Group Ltd,Health Care Providers & Services
      HomeServe plc,Commercial Services & Supplies
      Hootsuite Media Inc,Internet Software & Services
      Hopwells Ltd,Food & Staples Retailing
      Horizon Nuclear Power Limited,Electric Utilities
      Hounslow and Richmond Community Healthcare NHS Trust,Health Care Providers & Services
      House of Fraser,Multiline Retail
      Howard de Walden Estates Holdings Ltd,Real Estate Management & Development
      Howard Kennedy LLP,Professional Services
      Howdens Joinery Co,Trading Companies & Distributors
      HOYA Group,Health Care Equipment & Supplies
      HP Inc,Technology Hardware, Storage & Peripherals
      HPC Healthline Limited,Health Care Equipment & Supplies
      HS1 Limited,Transportation Infrastructure
      HSBC Holdings plc,Banks
      HSS Hire Group plc,Trading Companies & Distributors
      HSS Hire Group plc,Trading Companies & Distributors
      Hudson Global Resources Limited,Professional Services
      Hugh James LLP,Professional Services
      Hughes TV And Audio Limited,Specialty Retail
      HUGO BOSS  AG,Textiles, Apparel & Luxury Goods
      Huhtamaki OYJ,Containers & Packaging
      Hull and East Yorkshire  Hospitals NHS Trust,Health Care Providers & Services
      Huntapac Produce Ltd,Food Products
      Hunter Boot Limited,Textiles, Apparel & Luxury Goods
      Hunting PLC,Energy Equipment & Services
      Huntington Ingalls Industries Inc,Aerospace & Defense
      Huntress Search Limited,Professional Services
      Huntsman International LLC,Chemicals
      Huntswood CTC Limited,Professional Services
      Huntsworth plc,Media
      Hurst Morris Associates Limited (t/a HMA Creative),Media
      Hutchison Ports (UK) Ltd,Transportation Infrastructure
      Hutton Construction Ltd,Construction & Engineering
      Huws Gray Building Materials,Trading Companies & Distributors
      HW Martin Holdings Ltd,Commercial Services & Supplies
      Hyde Group Holdings,Machinery
      Hyde Housing Association Ltd,Real Estate Management & Development
      Hyde Vale Limited,Real Estate Management & Development
      Hydraforce Hydraulics Limited,Machinery
      Hydratight Limited,Machinery
      Hydrogen Group PLC,Professional Services
      Hydroscand UK Ltd,Specialty Retail
      Hymans Robertson LLP,Professional Services
      Hyperion Insurance Group,Insurance
      Hyundai Motor UK Limited ,Specialty Retail
      IAG Cargo Limited,Air Freight & Logistics
      Ian Allan Travel,Hotels, Restaurants & Leisure
      IBI Group Inc,Professional Services
      Ibstock PLC,Construction Materials
      IC Group A/S,Textiles, Apparel & Luxury Goods
      IC Group A/S,Textiles, Apparel & Luxury Goods
      ICAEW Ltd,?Diversified Consumer Services
      ICE Plumbing and Water Services Limited,Water Utilities
      Icelandic Seachill,Food Products
      ICF International,Professional Services
      ICICI Bank UK Plc,Banks
      Ickenham Travel Group plc,Hotels, Restaurants & Leisure
      Icon Clinical Research (U.K.) Ltd,Life Sciences Tools & Services
      ICTS (UK) Limited,?Transportation Infrastructure
      Ideal Boilers,Household Durables
      Ideal Industries Inc,Household Durables
      Idemitsu Kosan Co,Oil, Gas & Consumable Fuels
      IDEXX Laboratories Inc,Pharmaceuticals, Biotechnology & Life Sciences
      IDH Group Limited,Health Care Providers & Services
      IDOM Group,Construction & Engineering
      IESA Limited,IT Services
      IEWC Corp,Trading Companies & Distributors
      IFG Group plc,Diversified Financial Services
      IG Design Group PLC,Household Durables
      IG Group Holdings Plc,Capital Markets
      Iglu.com Ltd,Hotels, Restaurants & Leisure
      IH Mobility Holdings (UK) Limited,Distributors
      IHS Markit Ltd,Professional Services
      IHS Markit Ltd,Professional Services
      IK Investment Partners Ltd,Capital Markets
      Ikano Bank,Banks
      IKEA Limited,Specialty Retail
      IKO plc,Building Products
      IKON Construction Ltd,Construction & Engineering
      Illinois Tool Works Inc (ITW),Machinery
      Imagination Europe Ltd,Media
      Imagination Technologies Group plc,Semiconductors and Semiconductor Equipment
      Imagine Cruising,Hotels, Restaurants & Leisure
      IMC Worldwide Ltd,Professional Services
      IMI PLC,Machinery
      IMO Car Wash Group Limited,Diversified Consumer Services
      Impact Contracting Solutions Limited ,Professional Services
      Impellam Group plc,Professional Services
      Imperial Brands plc,Tobacco
      Imperial College Healthcare NHS Trust,Health Care Providers & Services
      Imperial London Hotels Group Ltd,Hotels, Restaurants & Leisure
      Imperva,Software
      Imtech UK Ltd,Construction & Engineering
      Inchcape plc,Distributors
      Inchcape Shipping Services Limited,Transportation Infrastructure
      Inchcape UK,?Distributors
      Incisive Media Limited,Media
      Incisive Media Ltd,Media
      Incommunities Group,Real Estate Management & Development
      Indeed UK Operations Ltd,?Professional Services
      Independent Clinical Services Group Ltd,Health Care Providers & Services
      Indian Hotel Company Limited,Hotels, Restaurants & Leisure
      Indivior PLC,Pharmaceuticals
      Industrial and Commercial Bank of China Limited,Banks
      Industrial Turbine Company (UK) Ltd,Machinery
      Inenco Group Limited,Professional Services
      Infineon Technologies AG,Semiconductors and Semiconductor Equipment
      Infinera Corporation,Communications Equipment
      Infinis Energy Limited,Independent Power and Renewable Electricity Producers
      Informa plc,Media
      Infosys Ltd,IT Services
      Ingenico Group ,Electronic Equipment, Instruments & Components
      Ingenious Capital Management Limited,Capital Markets
      Ingeus UK Ltd,Professional Services
      Inghams,Food Products
      Ingram Micro (UK) Ltd,?Electronic Equipment, Instruments & Components
      InHealth Group Limited,Health Care Providers & Services
      Inland Homes plc,Real Estate Management & Development
      Inmarsat plc,Diversified Telecommunication Services
      Innocent Drinks,Beverages
      Innospec Inc,Chemicals
      Inpex Corp,Oil, Gas & Consumable Fuels
      Insight Direct (UK) Limited,Electronic Equipment, Instruments & Components
      Insights 2 Communication LLP (i2c),Professional Services
      Inspectorate International Limited,Professional Services
      Instant Cash Loans Limited (t/a The Money Shop),Multiline Retail
      Institute of Physics (The),Diversified Consumer Services
      Insuletics Ltd,?Electrical Equipment
      Integrated Dental Holdings Ltd,Health Care Providers & Services
      Integrated Pathology Partnerships Ltd,Health Care Providers & Services
      Intel Corp,Semiconductors and Semiconductor Equipment
      Intelsat Global Sales & Marketing Ltd,Electronic Equipment, Instruments & Components
      Inter Terminals Limited,Oil, Gas & Consumable Fuels
      Intercity Technology Ltd,IT Services
      Interconnector (UK) Limited,Oil, Gas & Consumable Fuels
      InterContinental Hotels Group,Hotels, Restaurants & Leisure
      Interfloor Limited,Building Products
      InterGen Services Inc,Electric Utilities
      INTERMEDIATE CAPITAL GROUP PLC,Capital Markets
      International Consolidated Airlines Group SA (IAG),Airlines
      International Exhibition Co-Operative Wine Society Ltd,Beverages
      International Financial Data Services Limited ,IT Services
      International Flavours & Fragrances Inc,Chemicals
      International Greetings UK Ltd,Paper & Forest Products
      International Nuclear Solutions Limited (INS),Construction & Engineering
      International Paper Company,Paper & Forest Products
      International Personal Finance plc,Consumer Finance
      International Plywood (Importers) Plc,Construction Materials
      International Power Ltd,Independent Power and Renewable Electricity Producers
      International SOS Assistance (UK) Ltd,Health Care Providers & Services
      Interpublic Group of Companies (The),Media
      Interquest Group PLC,Professional Services
      Interserve Plc,Commercial Services & Supplies
      Intertek Group plc,Professional Services
      Intervet UK Limited,Pharmaceuticals 
      Interxion Carrier Hotel Limited,IT Services
      intu Properties plc,Equity Real Estate Investment Trusts (REITs)
      Inver House Distillers Ltd,Beverages
      Investec plc,Banks
      Investigo Limited,Professional Services
      Ipsen Limited,Pharmaceuticals
      Ipsos MORI,Media
      iQ Student Accommodation Ltd,Real Estate Management & Development
      IQE,Semiconductors & Semiconductor Equipment
      IRESS (UK) Limited,Software
      Irwin Mitchell LLP,Professional Services
      ISG plc,Construction & Engineering
      Ishida Europe Ltd,Machinery
      ISS UK Limited,Commercial Services & Supplies
      ITIC Specialist Professional Indemnity Insurance,Insurance
      ITN (Independent Television News Limited) ,Media
      Itsu Limited,Hotels, Restaurants & Leisure
      ITV plc,Media
      Itw Limited,Machinery
      ITWP Acquisitions Limited,Capital Markets
      IWG PLC,Commercial Services & Supplies
      J A Kemp Limited,Professional Services
      J O Sims Ltd,Distributors
      J Sainsbury plc,Food & Staples Retailing
      J Tomlinson Limited,Construction & Engineering
      J. Barbour and Sons Ltd,Textiles, Apparel & Luxury Goods
      J. Coffey Construction,Construction & Engineering
      J. Murphy & Sons Limited,Construction & Engineering
      Jabil Circuit Limited,Electronic Equipment, Instruments & Components
      Jack Morton Worldwide Ltd,Media
      Jack Wills Limited,Textiles, Apparel & Luxury Goods
      Jackson Civil Engineering Group Ltd,Construction & Engineering
      Jacobs U.K. Limited,Construction & Engineering
      Jaguar Land Rover Ltd,?Automobiles
      James Burrell Builders Merchants,Building Products
      James Cropper plc,Paper & Forest Products
      James Dewhurst Ltd,Textiles, Apparel & Luxury Goods
      James Finlay Limited,Food Products
      James Fisher and Sons plc ,Oil, Gas & Consumable Fuels
      James Hargreaves (Plumbers Merchants) Ltd,Specialty Retail
      James Hutton Institute (The),Professional Services
      James Johnston & Co. of Elgin Limited,Textiles, Apparel & Luxury Goods
      James Johnston & Co. of Elgin Limited (t/a Johnstons of Elgin),Textiles, Apparel & Luxury Goods
      James Jones & Sons Limited,Paper & Forest Products
      James T. Blakeman & Co. Ltd,Food Products
      Jamie's Italian Limited,Hotels, Restaurants & Leisure
      Jane Street Financial Ltd ,?Capital Markets
      Janssen-Cilag Limited,Pharmaceuticals
      Jarden Consumer Solutions,Household Durables
      Jardine Lloyd Thompson Group PLC,Insurance
      Jato Dynamics Limited,Machinery
      Javelin Global Commodities Holding LLP,Trading Companies & Distributors
      JCB Service,Machinery
      JCDecaux UK Ltd,Media
      JD Sports Fashion PLC,Specialty Retail
      JD Wetherspoon PLC,Hotels, Restaurants & Leisure
      Jefferies International Ltd,Capital Markets
      Jehu Group Ltd,Construction & Engineering
      Jeld-Wen UK Ltd,Distributors
      Jerram Falkus Construction Ltd,Construction & Engineering
      Jessup Brothers Limited,Construction & Engineering
      JFC International (Europe) GmbH,Food & Staples Retailing
      Jigsaw,Specialty Retail
      Jimmy Choo PLC,Textiles, Apparel & Luxury Goods
      Jisc,Professional Services
      JLA Limited,Trading Companies & Distributors
      Jo Malone Ltd,Personal Products
      Jockey Club (The),Hotels, Restaurants & Leisure
      Joh. Berenberg, Gossler & Co. Kg,Diversified Financial Services
      John Bean Technologies Corporation (JBT),Machinery
      John Laing Group plc,Construction & Engineering
      John Lewis Partnership plc,Food & Staples Retailing
      John Menzies plc ,Distributors
      John Mills Ltd (JML),Internet & Direct Marketing Retail
      John Sisk & Son Ltd,Construction & Engineering
      John Smith & Son Group Ltd,Diversified Consumer Services
      John Wiley & Sons Limited,Media
      John Wood Group plc,Energy Equipment & Services
      Johnson & Johnson Services Inc,Health Care Providers & Services
      Johnson Controls International plc,Building Products
      Johnson Matthey North America Inc,Metals & Mining
      Johnson Matthey plc,Chemicals
      Johnson Service Group plc,Commercial Services & Supplies
      Johnston Press plc,Media
      Jones Lang LaSalle Incorporated (t/a JLL),Real Estate Management & Development
      Jordans & Ryvita Company (The),Food Products
      Joseph Heler Limited,Food, Beverage & Tobacco
      Joseph Rowntree Foundation,Commercial Services & Supplies
      JOST UK,Machinery
      Journey Group Limited,Transportation Infrastructure
      JS Group Limited,?Commercial Services & Supplies
      JSA Services Ltd,Professional Services
      Jupiter Fund Management plc,Capital Markets
      Just Eat plc,Internet Software & Services
      JX Nippon Oil & Energy Europe Limited,Oil, Gas & Consumable Fuels
      K Line Group,Marine
      K+S Aktiengesellschaft,Chemicals
      K2  Partnering  Solutions  Holding  Co  Ltd,IT Services
      K3 Business Technology Group PLC ,Software
      Kaba Ltd,Electronic Equipment, Instruments & Components
      KAEFER Ltd,Construction & Engineering
      Kainos,IT Services
      Kajima Europe Limited,Real Estate Management & Development
      Kames Capital plc,Capital Markets
      Kao Corporation ,Personal Products
      Kaplan International Colleges,Diversified Consumer Services
      Karro Food Group Ltd,Food Products
      Kautex Unipart Limited,Auto Components
      Kavli Ltd,Food Products
      KAZ Minerals PLC ,Metals & Mining
      KCOM Group PLC,Diversified Telecommunication Services
      Kddi Europe Limited,IT Services
      Kee Safety Group Limited,Commercial Services & Supplies
      Keele Univeristy,Diversified Consumer Services
      Keelings Farm Fresh,Food & Staples Retailing
      Kelda Group Ltd,Water Utilities
      Keller Group plc,Construction & Engineering
      Kellogg Brown & Root Limited,Construction & Engineering
      Kellogg Company,Food Products
      Kelly Group Ltd,Professional Services
      Keltbray Limited,Construction
      Keltbray Limited,Construction & Engineering
      Kemet Corp,IT Services
      Kennametal U.K. Limited,Trading Companies & Distributors
      Kennedys Law LLP,Professional Services
      Kent Community Health NHS Foundation Trust,Health Care Providers & Services
      Kent Foods Ltd,Food & Staples Retailing
      Kentucky Fried Chicken (Great Britain) Ltd,Hotels, Restaurants & Leisure
      Keoghs LLP,Professional Services
      Keoghs LLP,Professional Services
      Kerfoot Group Ltd (The),Food Products
      Kering,Textiles, Apparel & Luxury Goods
      Kerridge Commercial Systems Limited,Software
      Keyence Corporation,Electronic Equipment, Instruments & Components
      Keysight Technologies UK Ltd,Electronic Equipment, Instruments & Components
      Kier Group plc,Construction & Engineering
      Killik & Co LLP,Capital Markets
      Kimball Electronics Group,Electronic Equipment, Instruments & Components
      Kimberly-Clark Corp,Household Products
      Kinapse Ltd,Professional Services
      Kinaxia Logistics,Air Freight & Logistics
      King's College London,Diversified Consumer Services
      King's Cross Central Limited Partnership,Real Estate Management & Development
      King’s Cross Central Limited Partnership,Real Estate Management & Development
      Kingfisher plc,Specialty Retail
      Kingsland Drinks Ltd,Beverages
      Kingspan Group plc,Building Products
      Kingston Smith LLP,Professional Services
      Kingston University,Diversified Consumer Services
      Kingstown Works Ltd,Commercial Services & Supplies
      Kiril Mischeff Group Ltd,Food Products
      Kirkland & Ellis International LLP,Professional Services
      Kisimul Group Limited,Diversified Consumer Services
      Kitchen Craft of Canada,Household Durables
      KKR & Co. L.P,Capital Markets
      KLA-Tencor Corporation,Semiconductors and Semiconductor Equipment
      KMS Media Limited ,Media
      Knauf Insulation Ltd,Building Products
      Knauf UK GmbH,Construction Materials
      Knight Frank LLP,Real Estate Management & Development
      Knights of Old Group Ltd,Road & Rail
      Koch Ag & Energy Solutions,?Financials
      Koch Chemical Technology Group Limited,Machinery
      KOEI TECMO HOLDINGS CO,Software
      Koito Europe Limited,Auto Components
      Kolhberg Kravis Roberts & Co.Â Partners LLP,Capital Markets
      Komatsu UK Limited,Machiney
      Kone plc,Machinery
      Konecranes UK plc,Machinery
      Konica Minolta Business Solutions (UK) Limited,Commercial Services & Supplies
      Konica Minolta Business Solutions Denmark a/s,Technology Hardware, Storage & Peripherals
      Konica Minolta Business Solutions Europe GmbH,Konica Minolta Business Solutions Europe GmbH
      Koninklijke Philips N.V,Health Care Equipment & Supplies
      Koppers Inc,Chemicals
      Korn Ferry Hay Group Limited,Professional Services
      KPMG LLP,Professional Services
      Kraft Heinz Foods Company,Food Products
      Kraton Corporation,Chemicals
      Kroll Inc,Commercial Services & Supplies
      Krones Group,Machinery
      KSB Group,Machinery
      Kuehne + Nagel Limited,Air Freight & Logistics
      Kuoni Gullivers Travel Associates (GTA),Hotels, Restaurants & Leisure
      Kustom Kit,Specialty Retail
      Kuwait Petroleum International Aviation Co. Ltd,?Distributors
      Kuwait Petroleum International Limited,Oil, Gas & Consumable Fuels
      Kwik-Fit (GB) Limited,Diversified Consumer Services
      KWM Europe LLP,Professional Services
      KYB Corporation,Auto Components
      KYOCERA Document Solutions (UK) Limited,Electronic Equipment, Instruments & Components
      L Brands Inc,Specialty Retail
      L.G.Harris & Co Ltd ,Building Products
      L'Oreal Ltd,Personal Products
      L&Q New Homes Limited,Real Estate Management & Development
      L3 Commercial Training Solutions,Aerospace & Defense
      LA International Computer Consultants Ltd,Commercial Services & Supplies
      Laboratories Darphin S.A.S,Personal Products
      Ladbrokes Coral Group plc,Hotels, Restaurants & Leisure
      Laing O'Rourke Group,?Construction & Engineering
      Laing O’Rourke Group,Commercial Services & Supplies
      Lakehouse plc,Commercial Services & Supplies
      Lakeland Dairies Co-operative Society Limited,Food Products
      Lakesmere Group,Construction & Engineering
      Laleham Health and Beauty Ltd,Personal Products
      Lam Research Institute Sarl,Semiconductors & Semiconductor Equipment
      Lamb Weston / Meijer V.O.F,Food Products
      Lambert Smith Hampton Group Limited,Professional Services
      Lamprell plc,Energy Equipment & Services
      Lancashire Care NHS Foundation Trust,Health Care Providers & Services
      Lancashire Holdings Limited,Insurance
      Lancaster University,Diversified Consumer Services
      Lanchester Group,?Hotels, Restaurants & Leisure
      Land Securities Group plc,Equity Real Estate Investment Trusts (REITs)
      Lander Automotive Ltd,Auto Components
      Landis+Gyr Ltd,Electronic Equipment, Instruments & Components
      Landmark Information Group Limited,Internet Software & Services
      Lane Clark & Peacock LLP,Professional Services
      Langley Holdings plc,Machinery
      LantmÃ¤nnen Unibake UK Ltd,Food & Staples Retailing
      Lanxess,Chemicals
      LANXESS Solutions US Inc,Chemicals
      Late Rooms Limited,Hotels, Restaurants & Leisure
      Law Society Group (The),Commercial Services & Supplies
      Lawcris Panel Products Limited,Construction Materials
      Lawsons (Whetstone) Ltd,?Trading Companies & Distributors
      Leadiant Biosciences Ltd,Pharmaceuticals
      Learning Technologies Group Plc,Diversified Consumer Services
      LeasePlan Corporation N.V,Diversified Financial Services
      LED Group,Specialty Retail
      Leeds Beckett University,Diversified Consumer Services
      Leeds Teaching Hospitals NHS Trust,Health Care Providers & Services
      Legal & General Group plc,Insurance
      Legg Mason Investments (Europe) Limited,Capital Markets
      Leggett & Plattorporated,Household Durables
      LEGO Group,?Leisure Products
      Legrand Electric Ltd,Electrical Equipment
      Leicester Clinical Commissioning Group,Health Care Providers & Services
      Leidos Supply Limited,?IT Services
      Lely (U.K.) Ltd,Trading Companies & Distributors
      Lendlease Europe Holdings Ltd,Real Estate Management & Development
      Lenlyn Holdings Limited,Consumer Finance
      Lenovo,Technology Hardware, Storage & Peripherals
      Leo Pharma A/S,Pharmaceuticals 
      Leonardo Mw Ltd,Electronic Equipment, Instruments & Components
      Level 3 Communications UK Limited,Diversified Telecommunication Services
      Levi Strauss & Co,Textiles, Apparel & Luxury Goods
      Levi, Ray & Shoup (LRS),Software
      Lewis Civil Engineering Ltd ,Aerospace & Defense
      Lewis Silkin LLP,Professional Services
      Leyes lane Pharmacy Ltd,? [comp with other pharmacies]
      LFF UK,Food products
      LG Electronics U.K. Ltd,Household Durables
      LGC Group,Professional Services
      Lhoist UK Limited,Construction Materials
      Liberata UK Limited,Commercial Services & Supplies
      Liberty Gas Group Limited,Commercial Services & Supplies
      Liberty Global plc,Media
      Liberty House Limited,Metals & Mining
      Liberty Specialty Markets,Insurance
      Liberty Specialty Markets,Insurance
      Liberum Capital Limited,Capital Markets
      Lidl Northern Ireland GmbH,Food & Staples Retailing
      Lifeplus Europe Limited,Pharmaceuticals
      Lifetime Training Group Limited,Diversified Consumer Services
      Lifeways Community Care Limited,Health Care Providers & Services
      Lime Management Limited   ,?Hotels, Restaurants & Leisure
      Lincoln Electric Holdings,Machinery
      Lincolnshire Co-operative Limited,Commercial Services & Supplies
      Lincolnshire Community Health Services NHS Trust,Health Care Providers & Services
      Lincs Wind Farm Limited,Independent Power and Renewable Electricity Producers
      Linde Material Handling (UK) Ltd,Trading Companies & Distributors
      Linden Foods Limited,Food Products
      Lindsell Train Limited,Capital Markets
      Lindum Group Ltd,Construction & Engineering
      Line Management Group Ltd,Communications Equipment
      Linklaters LLP,Professional Services
      LINPAC Group Limited,Containers & Packaging
      Lion Re:Sources UK Limited,Diversified Financial Services
      Liontrust Asset Management Plc,Capital Markets
      Liquid Friday Ltd,Professional Services
      Liquid Personel Limited,Professional Services
      Listers Group Limited,Specialty Retail
      Liv-Ex Limited,Beverages
      Live Nation (Music) UK Limited,Internet Software & Services
      Liverpool Football Club and Athletic Grounds Limited,Hotels, Restaurants & Leisure
      Liverpool John Moores University,Diversified Consumer Services
      Liverpool School of Tropical Medicine ,Diversified Consumer Services
      Lloyd Motors Ltd,Specialty Retail
      Lloyd Shoe Company (Holdings) Limited,Specialty Retail
      Lloyds Banking Group plc,Banks
      Lloyds Pharmacy Clinical Homecare Ltd,Food & Staples Retailing
      Lloyds Pharmacy Limited,Food & Staples Retailing
      LOC Group Holdings Limited,Professional Services
      Lockheed Martin Corporation,Aerospace & Defense
      Lockheed Martin Corporation,Aerospace & Defense
      Lockton International Holdings Ltd,Insurance
      Locum Software Services Ltd,Software
      Logicalis UK Limited,IT Services
      Logitech,Technology Hardware, Storage & Peripherals
      Logson Group,Containers & Packaging
      London Business School,Diversified Consumer Services
      London City Airport Limited ,Airlines
      London Luton Airport Operations Limited,Transportation Infrastructure
      London Metal Exchange Limited,Capital Markets
      London Metropolitan University,Diversified Consumer Services
      London North West Healthcare NHS Trust,Health Care Providers & Services
      London North West Healthcare NHS Trust,Health Care Providers & Services
      London School of Hygiene and Tropical Medicine,Diversified Consumer Services
      London South Bank University (LSBU),Diversified Consumer Services
      London Square Limited,Real Estate Management & Development
      London Stock Exchange Group plc,Capital Markets
      LondonMetric Property PLC,Equity Real Estate Investment Trusts (REITs)
      Long Clawson Dairy Ltd,Food Products
      Lonmin Plc,Metals & Mining
      Lonrho Ltd,Industrial Conglomerates
      Lookers PLC,Specialty Retail
      Loomis UK Limited,Commercial Services & Supplies
      Loughborough University,Diversified Consumer Services
      Louis Vuitton UK Limited,Specialty Retail
      Loungers Ltd,Hotels, Restaurants & Leisure
      Lovering Foods Ltd,Food & Staples Retailing
      Low & Bonar plc,Construction Materials
      Lowell Financial Ltd,Diversified Financial Services
      Lowell Solicitors Limited,Professional Services
      LTE Group (t/a The Manchester College),Diversified Consumer Services
      Lubrizol Corporation (The),Chemicals
      Lucy Group Limited,Industrial Conglomerates
      Lululemon Athletica Inc,Textiles, Apparel & Luxury Goods
      Lush Group (The),Personal Products
      Luxottica Retail UK Limited ,?Specialty Retail
      LWC drinks Limited,Beverages
      Lynas Foodservice Ltd,Road & Rail
      Lynn's Country Foods Limited,Food Products
      Lyreco UK Limited,Commercial Services & Supplies
      M J Birtwistle & Co Ltd,Food Products
      M.A.C. Cosmetics Inc,?Personal Products
      Mabanaft Limited,Oil, Gas & Consumable Fuels
      Macarthys Laboratories Limited (t/a Martindale Pharma),Pharmaceuticals
      MacDonald Hotels Limited,Hotels, Restaurants & Leisure
      Mace Group Ltd,Construction & Engineering
      Macfarlane Group plc,Trading Companies & Distributors
      Machine Mart Ltd,Specialty Retail
      Maclay Murray & Spens LLP,Professional Services
      Macmillan Publishers International Limited ,Media
      Macquarie Group Limited,Capital Markets
      Macquarie Group Limited,Capital Markets
      Mactaggart & Mickel Group Limited ,Aerospace & Defense
      Maersk Line A/S,Marine
      Magnitude Software,Software
      Maiden Holdings Ltd,Insurance
      Makalu Digital Marketing Ltd,Media
      Makita (UK) Ltd,Machinery
      Malcolm Group Ltd (The),Road & Rail
      Mallaghan Engineering Ltd,Machinery
      Mallinckrodt plc,Pharmaceuticals
      Malvern Instruments Ltd,?Electronic Equipment, Instruments & Components
      Mamas & Papas Ltd,Multiline Retail
      Mammoet UK Ltd,?Commercial Services & Supplies
      Man Group plc,Capital Markets
      MAN SE,Machinery
      Manchester City FC,Media
      Manchester Growth Company (the),Professional Services
      Manchester Metropolitan University,Diversified Consumer Services
      Manchester United Limited,Media
      Manor Fresh Ltd,Distributors
      Mapei U.K. Ltd,Chemicals
      MaplesFS Ltd,Capital Markets
      Mapletree Investments Pte Ltd,Capital Markets
      Maplin Electronics Ltd,Specialty Retail
      Marathon Asset Management LLP,Capital Markets
      Marbank Construction Limited,Construction & Engineering
      Maria Mallaband Care Group Ltd,Health Care Providers & Services
      Marie Stopes International ,Health Care Providers & Services
      Maris Interiors LLP,Commercial Services & Supplies
      Markel International Limited,Insurance
      Marlborough Communications Ltd,?Electronic Equipment, Instruments & Components
      Marlborough Fund Managers Ltd,Capital Markets
      Marriott Hotels Ltd,Hotels, Restaurants & Leisure
      Mars Incorporated,Food Products
      Marshall Construction Ltd,Construction & Engineering
      Marshall Motor Holdings PLC,Specialty Retail
      Marshall Wace LLP,Capital Markets
      Marshalls plc,Construction Materials
      Marston (Holdings) Limited,Commercial Services & Supplies
      Marston's plc,Hotels, Restaurants & Leisure
      Martin Currie Investment Management,Capital Markets
      Martin Retail Group Ltd,Food & Staples Retailing
      Marton Recruitment ltd,Professional Services
      Marubeni Corporation,Trading Companies & Distributors
      Marubeni-Komatsu Limited,Trading Companies & Distributors
      Marwood Group Limited,Machinery
      Marylebone Cricket Club,?Hotels, Restaurants & Leisure
      MAS Recruitment Limited,Professional Services
      Masco Corporation,Building Products
      Masco UK Window Group Limited,Specialty Retail
      Masonite International Corporation,Building Products
      Massey Bros (Feeds) Ltd,Food Products
      Mastek (UK) Ltd,Software
      Mastercard Inc,IT Services
      Matalan Retail Limited,Specialty Retail
      Matchstick Men Group,?Commercial Services & Supplies
      Matrix APA (UK) Ltd,Commercial Services & Supplies
      Matrix Control Solutions Ltd,?Distributors
      Matrix SCM Ltd,Internet Software & Services
      Matthew Algie & Co Ltd,Food Products
      Mauser UK. Ltd,Containers & Packaging
      Mawdsley-Brooks & Company Ltd,Health Care Providers & Services
      Maxell Europe Ltd,Technology Hardware, Storage & Peripherals
      Maxim Integrated,Semiconductors and Semiconductor Equipment
      Maximus Health and Human Services Ltd,Professional Services
      MaxLinear Inc,Semiconductors and Semiconductor Equipment
      Mayborn Group Limited,Personal Products
      Mayer Brown International LLP,Professional Services
      Mayflex Group,Trading Companies & Distributors
      Mazars LLP,Professional Services
      MB Aerospace,Aerospace & Defense
      McArthurGlen Group,Real Estate Management & Development
      McAvoy Group Ltd,Construction & Engineering
      McBride Plc,Household Products
      McCarthy & Stone plc,Household Durables
      McColl's Retail Group,Food & Staples Retailing
      McCurrach UK Ltd,Media
      McDermott Building & Civil Engineering Ltd,Construction & Engineering
      McDonald's Restaurants Ltd ,Hotels, Restaurants & Leisure
      McGinley Group Limited,Professional Services
      McGinley Support Services (Infrastructure) Ltd,Professional Services
      McGoff and Byrne Ltd,Construction & Engineering
      McGregor Boyall Associates Ltd,Professional Serivces
      McKesson Global Procurement & Sourcing Limited (MGPSL),Commercial Services & Supplies
      McKinsey & Company Inc,Professional Services
      McLaren Construction Limited,Construction & Engineering
      Mclarens Global Limited,Insurance
      McMullen & Sons Ltd,Beverages
      McTaggart Group,Aerospace & Defense
      Mead Johnson Nutrition Co,Food Products
      Mears Group PLC,Commercial Services & Supplies
      Medical Research Council,Commercial Services & Supplies
      Mediclinic International. plc,Health Care Providers & Services
      Medline Industries Inc,Health Care Equipment & Supplies
      Medtronic Limited,Health Care Equipment & Supplies
      Megger Group Limited,Electronic Equipment, Instruments & Components
      Melin Homes,Real Estate Management & Development
      Melrose Industries PLC,Electrical Equipment
      Meltemi Ltd,Textiles, Apparel & Luxury Goods
      Meme Media,Media
      Memex Technology Limited,Software
      Mercedes AMG High Performance Powertrains Ltd (HPP),Auto Components
      Mercedes Benz UK Ltd,Specialty Retail
      Mercedes-Benz Financial Services UK Ltd,Consumer Finance
      Mercedes-Benz Truck & Van (NI),Automobiles
      Mercer Limited,Professional Services
      Merck & Co,Pharmaceuticals
      Merck Serono Ltd,Health Care Providers & Services
      Merck Sharp & Dohme Ltd,Pharmaceuticals
      Mercuria Energy Trading,Oil, Gas & Consumable Fuels
      Mercury Bondco Plc,Capital Markets
      Merit Medical Systems,Health Care Equipment & Supplies
      Merlin Entertainments plc,Hotels, Restaurants & Leisure
      Merlin Housing Society,Real Estate Management & Development
      Merrill Corporation,Professional Services
      Merseyrail Electrics 2002 Limited,Road & Rail
      Meta Limited,Construction & Engineering
      Metaltech uk Limited,Metals & Mining
      Metaswitch Networks Ltd ,Software
      Methods Advisory Limited,Professional Services
      Methods Business and Digital Technology Ltd,Professional Services
      MetLife Europe d.a.c,Insurance
      MetLife Europe Services Limited,Commercial Services & Supplies
      Metnor Group Limited,Construction & Engineering
      Mettler-Toledo Safeline Limited,Machinery
      Meyer Timber Ltd,Trading Companies & Distributors
      MÌ_ller UK & Ireland Group LLP,Food & Staples Retailing
      MÌ_nchener RÌ_ckversicherungs-Gesellschaft AG (Munich Re),Insurance
      Michael Kors (UK) Ltd,Textiles, Apparel & Luxury Goods
      Micheldever Tyre Services Limited,Distributors
      Micro Focus International plc,Software
      Microchip Technology Incorporated,Semiconductors & Semiconductor Equipment
      Micron Technology,Semiconductors & Semiconductor Equipment
      Microsoft Corporation,Software
      Mid Cheshire Hospitals NHS Foundation Trust,Health Care Providers & Services
      Midas Group Ltd,Construction & Engineering
      Midcounties Co-Operative Ltd,Food & Staples Retailing
      Middlesex University Higher Education Corporation,Diversified Consumer Services
      Midland Foods Ltd,Food & Staples Retailing
      Miki Travel Limited,Hotels, Restaurants & Leisure
      Mildren Construction Limited,Construction & Engineering
      Millennium Capital Partners LLP,Capital Markets
      Millennium Hotels & Resorts,Hotels, Restaurants & Leisure
      Miller Homes Group (UK) Limited (The),Household Durables
      Millgate Computer Systems Limited,IT Services
      Mills & Reeve LLP,Professional Services
      Millwood Designer Homes Limited,Household Durables
      Minor, Weir & Willis Ltd,Food & Staples Retailing
      Minster Law Limited,Professional Services
      Mintel Group Ltd,Professional Services
      Mirza UK Ltd,Textiles, Apparel & Luxury Goods
      Mishcon de Reya LLP,Professional Services
      Missguided Limited,Internet & Direct Marketing Retail
      Misys Global,Software
      Mitchells & Butlers plc,Hotels, Restaurants & Leisure
      Mitie Group plc,Commercial Services & Supplies
      Miton Asset Management Limited,Capital Markets
      Mitsubishi Corporation,Trading Companies & Distributors
      Mitsubishi Corporation International (Europe) plc,Industrial Conglomerates
      Mitsubishi Electric Europe B.V,Electrical Equipment
      Mitsubishi Heavy Industries Air Conditioning Europe.åÊ,Machinery
      Mitsubishi Heavy Industries Europe,Machinery
      Mitsubishi Hitachi Power Systems Europe Ltd,Electrical Equipment
      Mitsubishi Motors,Automobiles
      Mitsubishi Rayon Lucite Group Ltd,Chemicals
      Mitsubishi UFJ Trust and Banking Corporation,Capital Markets
      Mitsui & Co,Trading Companies & Distributors
      Mizkan Euro Ltd,Food Products
      Mizuho International plc,Capital Markets
      Mizuho Securities UK Holdings Ltd,Capital Markets
      Mizuno Corporation,Leisure Products
      MM (UK) Limited,Food & Staples Retailing
      MMCG Holdings Ltd,Real Estate Management & Development
      Mobile Account Solutions Ltd,Specialty Retail
      Modis International Ltd. ,IT Services
      Mole Valley Farmers Ltd,?Trading Companies & Distributors
      Molnlycke Health Care Limited,Health Care Providers & Services
      Mölnlycke Health Care Limited,Health Care Providers & Services
      Momentive Performance Materials Inc,Chemicals
      Mondi plc,Paper & Forest Products
      Mondrian Investment Partners Limited,Capital Markets
      moneyinfo limited,Commercial Services & Supplies
      Moneysupermarket.com Group PLC,Internet Software & Services
      Monier Redland Limited,Building Products
      Monitise plc,Software
      Mono Global Group Limited,?IT Services
      Monsoon Accessorize Ltd,Specialty Retail
      Montagu Evans LLP,Real Estate Management & Development
      Montgomery Transport Limited,Road & Rail
      Moody’s Group (Holdings) Unlimited,Capital Markets
      Moore Stephens LLP,Professional Services
      Moorepay Ltd,Internet Software & Services
      Moores Furniture Group Ltd,Building Products
      Morgan Advanced Materials PLC,Machinery
      Morgan Hunt UK Limited,Professional Services
      Morgan McKinley Ltd,Professional Services
      Morgan Sindall Group plc ,Construction & Engineering
      Morning Foods Limited,Food
      Morning Foods Limited,Food Products
      Morningside Pharmaceuticals Limited,Pharmaceuticals
      Morningstar Inc,Capital Markets
      Morphy Richards Limited,Distributors
      Morris Leisure ,Hotels, Restaurants & Leisure
      Morrison Utility Services Limited,?Construction & Engineering
      Morses Club PLC,Consumer Finance
      Morson International,Professional Services
      Mortgage Advice Bureau (Holdings) plc,Thrifts & Mortgage Finance
      Moss Bros Group plc,Specialty Retail
      Motability Operations Limited,Consumer Finance
      Mothercare Group plc,Multiline Retail
      Moto Hospitality Ltd,Hotels, Restaurants & Leisure
      Motorola Solutions Inc,Communications Equipment
      Mott MacDonald Group Ltd,Professional Services
      Mourant Ozannes LP,Professional Services
      Movianto UK Limited,Health Care Providers & Services
      Moy Park Ltd,Food Products
      Moyses Stevens Flowers Limited,Specialty Retail
      MS Amlin plc,Communications Equipment
      MS Amlin plc,Insurance
      MS Amlin plc,Insurance
      MS&AD Insurance Group Holdings Inc,Insurance
      MSC Industrial Supply Company,?Distributors
      MSCI Inc,Capital Markets
      MSI Group Limited,Professional Services
      MTI Technology Limited,IT Services
      MTR Corporation (Crossrail) Ltd,Road & Rail
      MTR Corporation Limited,Road & Rail
      MTrec Limited,Professional Services
      MTS Cleansing Services Ltd,Commercial Services & Supplies
      MUFG	Investor Services Holdings Ltd,Capital Markets
      Mulberry Group Plc,Textiles, Apparel & Luxury Goods
      Multi Packaging Solutions Global Holdings Limited ,Containers & Packaging
      Multisol Ltd,Chemicals
      Multiyork Furniture Ltd,Household Durables
      Mundipharma International Limited,Pharmaceuticals
      Mundipharma IT Services Ltd,Pharmaceuticals, Biotechnology & Life Sciences
      Mundipharma Research Limited,Health Care Providers & Services
      Murata Manufacturing Co,Electronic Equipment, Instruments & Components
      Murgitroyd & Company Limited,Professional Services
      Mutual Energy Limited,Electric Utilities
      Muzinich & Co. Ltd,Capital Markets
      MWH Constructors Ltd,Construction & Engineering
      MWUK Ltd,Specialty Retail
      Myers Group Limited,Food & Staples Retailing
      Mylan N.V,Pharmaceuticals
      N Brown Group PLC,Internet & Direct Marketing Retail
      NAHL Group plc,Media
      Nando's Chickenland Limited,Hotels, Restaurants & Leisure
      Napp Pharmaceuticals Ltd,Pharmaceuticals
      National Car Parks Limited,?Commercial Services & Supplies/ Diversified Consumer Services
      National Express Group plc,Road & Rail
      National Fostering Agency Group,Commercial Services & Supplies
      National Grid plc,Multi-Utilities
      National House Building Council,Construction & Engineering
      National Magazine Company Ltd. (The),Media
      National Nuclear Laboratory Ltd,Professional Services
      National Veterinary Services (NVS) Ltd,Health Care Providers & Services
      Nationwide Building Society,Banks
      Natixis S.A,Capital Markets
      NATS Holdings Limited,Transportation Infrastructure
      Natural Products Limited (NPW),Leisure Products
      Nature Delivered Limited,Food Products
      Nautilus International Risk Consultants Limited,Professional Services
      Navigant Consulting Europe Limited,Professional Services
      Navitas Life Sciences Limited,Health Care Providers & Services
      NCC Group plc,IT Services
      NCH Corporation,Industrial Conglomerates
      NCR Ltd,Technology Hardware, Storage & Peripherals
      Neal's Yard (Natural Remedies) Limited,Personal Products
      NEC Europe Ltd,?Technology Hardware, Storage & Peripherals
      NEC Group,Hotels, Restaurants & Leisure
      Neilcott Construction Group,Construction & Engineering
      Neon Underwriting Limited,Insurance
      Neopost Ltd,Commercial Services & Supplies
      NES Global Talent Limited,Professional Services
      NES Global Talent Ltd,Professional Services
      Nest Labs,Household Durables
      NestlÌ© UK Ltd,Food Products
      Net Temps,Professional Services
      NetApp Inc,Technology Hardware, Storage & Peripherals
      NetApp Inc,Technology Hardware, Storage & Peripherals
      NetNames Group Limited,Media
      Netwatch Ireland Lmt,Commercial Services & Supplies
      New England Seafood International Limited,Food Products
      New Look Retail Group Limited,Specialty Retail
      New Millennia Group Plc,Professional Services
      New Relic Inc,Internet Software & Services
      Newcastle Building Society,Thrifts & Mortgage Finance
      Newcastle College Group,Diversified Consumer Services
      Newcastle Gateshead Clinical Commissioning Group,?Health Care Providers & Services
      Newcastle International Airport Ltd,Transportation Infrastructure
      Newcastle University,Commercial Services & Supplies
      NewDay Cards Ltd,Consumer Finance
      Newell Brands Inc,Household Durables
      NewLaw Solicitors LLP,Professional Services
      Newport City Homes ,Real Estate Management & Development
      NewRiver REIT PLC,Equity Real Estate Investment Trusts (REITs)
      News Corp,Media
      Newton Europe Limited,Commercial Services & Supplies
      NEX Group plc,Capital Markets
      Next Fifteen Communications Group plc,Media
      NEXT plc,Multiline Retail
      Nexus Vehicle Management Ltd,?Road & Rail
      NFT Distribution Ltd,Air Freight & Logistics
      NFU Mutual,Capital Markets
      NG Bailey Group Limited,Construction & Engineering
      nGAGE Specialist Recruitment,Professional Services
      NGK Spark Plugs (UK) Ltd,Auto Components
      NHS Bath and North East Somerset Clinical Commissioning Group,Health Care Providers & Services
      NHS Brent Clinical Commissioning Group,Health Care Providers & Services
      NHS Bromley Clinical Commissioning Group,Health Care Providers & Services
      NHS Darlington Clinical Commissioning Group,Health Care Providers & Services
      NHS Dorset Clinical Commissioning Group,Health Care Providers & Services
      NHS East Lancashire Clinical Commissioning Group,Health Care Providers & Services
      NHS England,Commercial Services & Supplies
      NHS Hartlepool and Stockton-On-Tees Clinical Commissioning Group,Health Care Providers & Services
      NHS Leicester City Clinical Commissioning Group,Health Care Providers & Services
      NHS Leicestershire Partnership,Health Care Providers & Services
      NHS Mid Essex Clinical Commissioning Group,Health Care Providers & Services
      NHS Midlands and Lancashire Commissioning Support Unit,Health Care Providers & Services
      NHS Professionals,Health Care Providers & Services
      NHS Shared Business Services Limited,Health Care Providers & Services
      NHS South Kent Coast Clinical Commissioning Group,Health Care Providers & Services
      NIBC Bank N.V,Banks
      Nicholl (Fuel Oils) Ltd,Oil, Gas & Consumable Fuels
      Nicholls & Clarke Limited,Building Products
      Nicol Hugues Foodservice,Food & Staples Retailing
      Niftylift Ltd,Machinery
      Nikon Corporation,Household Durables
      Nikon Metrology UK Ltd,Electronic Equipment, Instruments & Components
      Nillorngruppen AB,Textiles, Apparel & Luxury Goods
      Nintendo Co,Software
      Nippon Gohsei (UK) Limited,Containers & Packaging
      Nippon Sheet Glass Co. Ltd,Building Products
      Nisa Retail Ltd,Food & Staples Retailing
      Nisbets plc ,?Trading Companies & Distributors
      Nissan Motor (GB) Limited,?Automobiles
      Nittan Co,Household Durables
      NLA Media Access Limited,Media
      NMB-Minebea UK Ltd,Aerospace & Defense
      Nobia AB,Household Durables
      Noble Caledonia Ltd,Hotels, Restaurants & Leisure
      Noble Corporation plc,Energy Equipment & Services
      Noble Foods Ltd,Food Products
      Noble Group Ltd,Trading Companies & Distributors
      Nomad Foods Europe Limited,Food Products
      Nomura Asset Management UK Limited,Capital Markets
      Nomura Capital Markets Limited,Capital Markets
      Nomura Europe Holdings plc,Capital Markets
      Nomura European Investment Limited,Capital Markets
      Norbain SD Ltd,?Electronic Equipment, Instruments & Components
      Norbrook Laboratories Limited,Pharmaceuticals 
      Norcros plc,Building Products
      Nordson Corporation,Machinery
      Norfolk and Suffolk NHS Foundation Trust,Health Care Providers & Services
      Norgine Limited,Pharmaceuticals 
      Norinchukin Bank (The),Banks
      Norkem Limited,Chemicals
      Norman Hay plc,Chemicals
      Norse Group Ltd,Commercial Services & Supplies
      Norsk Gjenvinning Group,Commercial Services & Supplies
      Norsk Gjenvinning Group,Commercial Services & Supplies
      Norsk Hydro ASA,Metals & Mining
      North British Distillery Company Limited,Beverages
      North Midland Construction plc,Construction & Engineering
      North of England Protecting and Indemnity Association Ltd. (The),Insurance
      North West Anglia NHS Foundation Trust,Health Care Providers & Services
      North Western Universities Purchasing Consortium,?Commercial Services & Supplies
      Northern and Shell plc,Media
      Northern Bank Limited t/a Danske Bank,Banks
      Northern Gas Networks Ltd,Gas Utilities
      Northern Ireland Electricity Networks Limited,Electric Utilities
      Northern Ireland Water Ltd,Water Utilities
      Northern Powergrid Holdings Company,Electric Utilities
      Northern Trust Company (The),Banks
      Northgate plc,Road & Rail
      Northgate Public Services (UK) Limited,IT Services
      Northrop Grumman Corporation,Aerospace & Defense
      Northumbria University,Diversified Consumer Services
      Northumbrian Water Limited,Water Utilities
      Norton Rose Fulbright LLP,Professional Services
      Norton Way Motors Limited,Specialty Retail
      Nostrum Oil & Gas PLC,Oil, Gas & Consumable Fuels
      Notcutts Ltd,Specialty Retail
      Notonthehighstreet Enterprises Ltd,Internet & Direct Marketing Retail
      Nottingham Building Society (The),Banks
      Nottingham City Transport Ltd,?Road & Rail
      Nottingham Trent University,Diversified Consumer Services
      Nottingham University Hospitals NHS Trust,Health Care Providers & Services
      Novanta Inc,Electronic Equipment, Instruments & Components
      Novartis AG,Pharmaceuticals
      Novo Nordisk A/S,Pharmaceuticals
      Novo Nordisk Ltd. ,Pharmaceuticles
      Novozymes A/S,Chemicals
      Novus Property Solutions Limited,Construction & Engineering
      npower Group PLC,Electric Utilities
      NPT Homes,Real Estate Management & Development
      NSK Europe Ltd,Machinery
      NSL Services Group,Commercial Services & Supplies
      NSSLGlobal Limited,Diversified Telecommunication Services
      NST Travel Group Ltd,Hotels, Restaurants & Leisure
      NTT Data UK,IT Services
      NTT Europe,IT Services
      NTT Security (UK) Limited,IT Services
      Number UK Ltd (The),Diversified Telecommunication Services
      Nutreco N.V,Food Products
      NWF Group plc,Oil, Gas & Consumable Fuels
      NXP Semiconductors,Semiconductors & Semiconductor Equipment
      NxStage Medical Inc,Health Care Equipment & Supplies
      O'Neill & Brennan Construction Ltd,Professional Services
      O2 (Ansco Arena Limited),?Leisure Facilities
      Oak Furniture Land,?Real Estate Management & Development/ Household Durables
      Oasis Dental Care Ltd,Health Care Providers & Services
      Oasis Fashions Limited,Textiles, Apparel & Luxury Goods
      Obr Construction Ltd,Construction & Engineering
      Ocado Group plc,Internet & Direct Marketing Retail
      Ocean Beauty Seafoods LLC,Food Products
      OCS Group Ltd,Commercial Services & Supplies
      Octo Telematics Ltd,Internet Software & Services
      Octopus Capital Limited,Capital Markets
      Octopus Recruitment Ltd,Professional Services
      Odey Asset Management LLP,Capital Markets
      Office Angels Limited ,Professional Services
      Office Depot UK Limited,?Commercial Services & Supplies
      OFFICE Holdings Ltd,Specialty Retail
      Office Team Ltd,Commercial Services & Supplies
      Ogilvie Group Limited ,?Industrial Conglomerates
      Oil Spill Response Limited,Oil, Gas & Consumable Fuels
      Old Mutual plc,Insurance
      Oliver James Associates Ltd,Professional Services
      Oliver Kay Ltd,Food & Staples Retailing
      Olleco Ltd,Food Products
      Olympus  KeyMed Group Ltd,Health Care Equipment & Supplies
      Omega plc,Household Durables
      Omex Agricultural Holdings Limited,Chemicals
      Omron Corporation ,Electronic Equipment, Instruments & Components
      OMV Aktiengesellschaft,Oil, Gas & Consumable Fuels
      Omya UK Ltd,Chemicals
      ON Semiconductor Corp,Semiconductors & Semiconductor Equipment
      One Call Recruitment Ltd,Professional Services
      One Vision Housing Limited,Real Estate Management & Developmen
      One51 Plastics Holdings Limited,Containers & Packaging
      OneSavings Bank plc,Banks
      Ongo Homes,Real Estate Management & Development
      OP Chocolate Ltd,Food Products
      Open GI International,Internet Software & Services
      Open Text UK Limited,IT Services
      Open University (The),Diversified Consumer Services
      Openfield Group Ltd,Food & Staples Retailing
      Opex Corp,Technology Hardware, Storage & Peripherals
      Ophir Energy plc,Oil, Gas & Consumable Fuels
      Opodo Ltd ,Internet & Direct Marketing Retail
      Optal Limited,Consumer Finance
      Optare Group Limited,Machinery
      Optionis Group,Professional Services
      Optoma Europe Limited,Technology Hardware, Storage & Peripherals
      Optos Plc,Health Care Equipment & Supplies
      Optum Health Solutions (UK) Ltd,Health Care Providers & Services
      Opus Energy Ltd,Gas Utilities
      Oracle Corporation UK Limited,Software
      Orange Brand Services Limited,Diversified Financial Services
      Orange Plant,Machinery
      Orangebox Ltd,Commercial Services & Supplies
      Orbis Investment Advisory Limited,Capital Markets
      Orbotech Holding U.K. Ltd,Electronic Equipment, Instruments & Components
      Orchard House Foods Limited ,Food, Beverage & Tobacco
      Ordnance Survey Limited,Media
      Origin UK Operations Limited,Chemicals
      Orion Engineering Services Limited,Professional Services
      Ornua Co-operative Limited,Food, Beverage & Tobacco
      Orona Group,Machinery
      Orrick, Herrington & Sutcliffe (UK) LLP ,Professional Services
      Ortho Clinical Diagnostics Inc,Health Care Equipment & Supplies
      Osborne Clarke,Professional Services
      Osborne Group,?Professional Services
      Oscar Mayer Limited,Food Products
      OSRAM Limited,Electrical Equipment
      Ossur UK Ltd,?Specialty Retail
      Otis Limited,Machinery
      Otsuka Pharmaceuticals (UK) Limited,Pharmaceuticals
      Outsauce Group Ltd,?Professional Services
      Outsource UK Ltd,Professional Services
      Overseas Development Institute,Health Care Providers & Services
      OVO Group Ltd,Capital Markets
      Owen Payne Recruitment Services Ltd,Professional Services
      Owens Corning,Building Products
      Oxford Brookes UniversityåÊ,Diversified Consumer Services
      Oxford HealthåÊNHSåÊFoundation TruståÊ,Health Care Providers & Services
      Oxford Instruments plc,Electronic Equipment, Instruments & Components
      Oxford Policy Management Ltd,Professional Services
      Oxford University Press Inc,Media
      P.D. Hook (Hatcheries) Ltd,Food Products
      P&O Ferries Ltd,P&O Ferries Ltd
      PA Consulting Group Limited,Professional Services
      PA Group Ltd,Media
      Pacy & Wheatley Limited,Construction & Engineering
      Paddy Power Betfair PLC,Hotels, Restaurants & Leisure
      PageGroup plc,Professional Services
      Paladone Products Ltd,Distributors
      Palladium International Limited,Professional Services
      Palletways (UK) Ltd,Road & Rail
      Panasonic Energy Europe NV,?Electrical Equipment
      Panasonic UK,Electronic Equipment, Instruments & Components
      Pandora,Textiles, Apparel & Luxury Goods
      Paneltex Ltd,Machinery
      Pantheon Ventures (UK) LLP,Capital Markets
      Paperchase Products Ltd,Specialty Retail
      Paragon Group Ltd,Commercial Services & Supplies
      Paragon Group of Companies plc,Banks
      Paragon Interiors Group Plc,Construction & Engineering
      Parex Limited,?Household Durables
      Park Cakes Limited,Food Products
      Park's (AYR) Limited,?Specialty Retail
      Parkdean Resorts Limited,Hotels, Restaurants & Leisure
      Parker Hannifin Manufacturing Limited,Machinery
      Parkwood Leisure Limited,Hotels, Restaurants & Leisure
      Parmley Graham Ltd,Electronic Equipment, Instruments & Components
      Parseq Ltd,?IT Services
      Parseq Ltd,IT Services
      Partners in Property (UK) Limited (t/a The Simplify Group),Real Estate Management & Development
      Parts Alliance Limited (The),Distributors
      Patagonia ,Textiles, Apparel & Luxury Goods
      Patheon UK Ltd,Pharmaceuticals
      Patients 2 People Ltd,Health Care Providers & Services
      Patisserie Holdings Plc,Hotels, Restaurants & Leisure
      Pattonair Ltd,Aerospace & Defense
      Paul Hartmann Ltd,Health Care Equipment & Supplies
      Paul Hastings LLP,Professional Services
      Paul Smith Ltd,Specialty Retail
      Pavers Ltd,Specialty Retail
      Paymentshield Limited,Insurance
      PayPoint plc,Commercial Services & Supplies
      Paysafe Group plc,IT Services
      PCI Pharma Services,Life Sciences Tools & Services
      PCL Transport 24/7 Limited,Commercial Services & Supplies
      PCMS Group plc,Software
      PD Ports Limited,Transportation Infrastructure
      PD&MS Group,Energy Equipment & Services
      Pearson Engineering Limited,Aerospace & Defense
      Pearson plc,Media
      Peel Holdings Land and Property (UK) Limited,Real Estate Management & Development
      Pegasystems Ltd,Software
      Pegler Yorkshire Group Ltd,Household Durables
      Pelican Rouge Coffee Solutions Limited,Food Products
      Pembroke Managing Agency Limited,Insurance
      Pencarrie Ltd,Textiles, Apparel & Luxury Goods
      Pendragon PLC,Specialty Retail
      Penguin Random House UK,Media
      Peninsula Business Services Limited,Professional Services
      Peninsula Group,Diversified Financial Services
      Peninsula Petroleum Limited,Oil, Gas & Consumable Fuels
      Penna plc,Professional Services
      Pennine Care NHS Foundation Trust,Health Care Providers & Services
      Penningtons Manches LLP,Professional Services
      Pennon Group plc,Water Utilities
      Pension Insurance Corporation plc,Insurance
      Pension Protection Fund,Capital Markets
      Penta Consulting Ltd,IT Services
      Pentagon Motor Holdings Limited,Specialty Retail
      Pentalver Transport Limited ,Marine
      Pentland Brands Ltd,Textiles, Apparel & Luxury Goods
      Peoples Cars Ltd,Specialty Retail
      Pepper (UK) Limited,?Thrifts & Mortgage Finance
      PepsiCo,Food Products
      Per Aarsleff (UK) Ltd,Construction & Engineering
      PERI Ltd,Construction & Engineering
      Perkins Engines Company Limited,Machinery
      Perkins+Will,?Professional Services
      Permira Advisers LLP,Professional Services
      Pernod Ricard UK Limited,Beverages
      Perrigo Company PLC,Pharmaceuticals
      Perrigo Company PLC,Pharmaceuticals
      Perry Ellis Europe Limited,Textiles, Apparel & Luxury Goods
      Perry Ellis Europe Limited,Textiles, Apparel & Luxury Goods
      Persimmon Group,Household Durables
      Personnel Hygiene Services Limited,Commercial Services & Supplies
      Pertemps Recruitment Partnership Limited,Professional Services
      Peter Brett Associates LLP,Construction & Engineering
      Petra Diamonds Limited,Metals & Mining
      Petrofac Limited,Energy Equipment & Services
      Petroleum Experts Limited,Software
      PETRONAS Energy Trading Limited,Independent Power & Renewable Electricity Producers
      Petropavlovsk Plc,Metals & Mining
      Pets at Home Group plc,Specialty Retail
      Petty Wood & Co Ltd,Food & Staples Retailing
      Peugeot Motor Company Plc,Specialty Retail
      Pfizer Inc,Pharmaceuticals
      PGL,Hotels, Restaurants & Leisure
      PH Glatfelter Company,Paper & Forest Products
      Phase Eight (Fashion & Designs) Limited,Textiles, Apparel & Luxury Goods
      Phelan Construction Limited,Construction & Engineering
      Philips Electronics UK Limited,Electrical Equipment
      Visit Company in Admin,Health Care Providers & Services
      Phoenix Partnership Ltd (TPP),Health Care Technology
      Phoenix Software Limited,IT Services
      PhotoBox Group Ltd,Internet Software & Services
      Pickfords Move Management Limited,Road & Rail
      Pillsbury Winthrop Shaw Pittman LLP,Professional Services
      PIMCO Europe Ltd,Capital Markets
      Pinsent Masons LLP,Professional Services
      Pioneer Europe NV,Specialty Retail
      Pirelli International Plc,Auto Components
      Pizza Hut UK LImited,Hotels, Restaurants & Leisure
      PizzaExpress Group Limited,Hotels, Restaurants & Leisure
      PJH Group Ltd,Distributors
      Places for People Ltd,Real Estate Management & Development
      Plastribution Limited,Trading Companies & Distributors
      Playtech PLC,Software
      Plexus Corp,Electronic Equipment, Instruments & Components
      Plexus Law Limited,Professional Services
      Plexus Ocean Systems Ltd,Oil, Gas & Consumable Fuels
      Plusnet plc,Diversified Telecommunication Services
      PMC Construction & Development Services Ltd,Household Durables
      PMP Recruitment Limited,Professional Services
      PMS International Group plc,Distributors
      PolyOne Corporation,Chemicals
      Polypipe Group plc,Building Products
      Pool Reinsurance Company Limited,Insurance
      Pope Woodhead & Associates Ltd. ,Professional Services
      Porsche Cars Great Britain Ltd,Automobiles
      Port of London Authority Ltd,Transportation Infrastructure
      Portakabin Ltd,Construction & Engineering
      Portman Travel Ltd,Hotels, Restaurants & Leisure
      Portsmouth Aviation Limited,Construction & Engineering
      Portsmouth Water Limited,Water Utilities
      Post Office (The),Air Freight & Logistics
      Poundland Limited,Multiline Retail
      Poundworld Retail Limited,Multiline Retail
      Poupart Ltd,Food & Staples Retailing
      Pöyry Plc,Professional Services
      PPD Global Ltd,Professional Services
      PPF Group Ltd,Professional Services
      PPG Industries (UK) Limited,Chemicals
      PQ Corporation,Chemicals
      PRA Health Sciences Inc,Life Sciences Tools & Services
      Practicus Limited,Professional Services
      PRADA S.p.A,Textiles, Apparel & Luxury Goods
      Praxair Techonology,Oil, Gas & Consumable Fuels
      Precision Castparts Corp,Aerospace
      Precision Colour Printing Ltd,Commercial Services & Supplies
      Precor Incorporated,Leisure Products
      Premex Group Limited,Health Care Providers & Services
      Premier Asset Management Group plc,Capital Markets
      Premier Foods plc,Food Products
      Premier Oil plc,Oil, Gas & Consumable Fuels
      Premier Paper Group Limited,Trading Companies & Distributors
      Premier Technical Services Group plc,Commercial Services & Supplies
      Premium Credit Limited,Consumer Finance
      Prestige Recruitment Specialists Limited,Professional Services
      Pricecheck Toiletries Limited,Distributors
      PricewaterhouseCoopers  LLP,Professional Services
      Primafruit Limited,Distributors
      Primark Stores Ltd,Specialty Retail
      Primary Health Properties PLC,Equity Real Estate Investment Trusts (REITs)
      Primetals Technologies Ltd,Metals & Mining
      Prince Minerals Limited,Metals & Mining
      Princebuild Ltd,Construction & Engineering
      Princes Group,Food & Staples Retailing
      Princess Yachts Limited,Machinery
      Proact IT UK Limited,IT Services
      Probrand Limited,Electronic Equipment, Instruments & Components
      Procter & Gamble Company (The),Household Products
      Procter & Gamble UK,Personal Products
      Produce Investments plc,Food Products
      Produce World Group Ltd,Food Products
      Profile Security Services Limited,Hotels, Restaurants & Leisure
      Project People Ltd,Professional Services
      Prologis UK Limited,Mortgage Real Estate Investment Trusts (REITs)
      Promethean World Plc,Diversified Consumer Services
      Prominent (Europe) Limited,Distributors
      prosource.it,IT Services
      Prospects Services Ltd,Diversified Consumer Services
      Protec Fire Detection plc,Electrical Equipment
      Provident Financial plc,Consumer Finance
      Prudential plc ,Insurance
      PSA Finance UK Limited,Diversified Financial Services
      Puma Energy Singapore Pte Ltd,Oil, Gas & Consumable Fuels
      Puma SE,Textiles, Apparel & Luxury Goods
      Punch Taverns plc,Hotels, Restaurants & Leisure
      Punjab National Bank (International) Limited,Banks
      PureCircle Ltd,Food Products
      PureGym Ltd,Hotels, Restaurants & Leisure
      Purple Foodservice Solutions Ltd,Hotels, Restaurants & Leisure
      PZ Cussons Plc Group,Household Products
      Q-Park Limited,Commercial Services & Supplies
      QA Group,Diversified Consumer Services
      Qantas Group,Airlines
      QBE Insurance Group Limited,Insurance
      Qdem Pharmaceuticals Limited,Pharmaceuticals
      Qiagen Limited,Life Sciences Tools & Services
      QinetiQ Group plc,Aerospace & Defense
      Qlik Technologies,Software
      QTS Group Ltd,Construction & Engineering
      Quadrature Capital Limited,Capital Markets
      Qualcomm Incorporated,Semiconductors & Semiconductor Equipment
      Quantum Clothing Group LtdåÊ,Textiles, Apparel & Luxury Goods
      Quantum Pharma Group Limited,Pharmaceuticals
      Quantum Pharma Plc,Pharmaceuticals
      Queen Ethelburga's Collegiate,Diversified Consumer Services
      Queen Mary University of London,Diversified Consumer Services
      Queens Park Rangers Football & Athletic Club Limited,Hotels, Restaurants & Leisure
      Queensgate Bow Opco Limited,Hotels, Restaurants & Leisure
      Quinn (London) Limited,Construction & Engineering
      Quinn Emanuel Urquhart & Sullivan UK LLP,Professional Services
      Quintain Limited,Real Estate Management & Development
      Quintessential Brands SA,Beverages
      Quorn Foods Ltd,Food Products
      R Swain & Sons Ltd,Road & Rail
      R. G. Carter Holdings Ltd,Construction & Engineering
      R.E.A. Holdings plc,Food Products
      R&H Hall Ltd,Food & Staples Retailing
      R&M Electrical Group Limited,Electrical Equipment
      R&W Civil Engineering Ltd,Construction & Engineering
      RAC Group Limited,Specialty Retail
      Rackspace ,Internet Software & Services
      Radcliffe Chambers ,Professional Services
      Radian Group Ltd,Commercial Services & Supplies
      Radius Payment Solutions Limited,Consumer Finance
      Radley + Co Ltd,Textiles, Apparel & Luxury Goods
      Rail Safety and Standards Board Ltd,Transportation Infrastructure
      Rakon Limited,Electronic Equipment, Instruments & Components
      Ralph Lauren Corporation,Textiles, Apparel & Luxury Goods
      Ramsay Health Care Ltd,Health Care Providers & Services
      Ranbaxy (UK) Limited,Health Care Providers & Services
      Randall & Quilter Investment Holdings Ltd,Insurance
      Randall Parker Foods Limited,Food Products
      Randgold Resources Limited,Metals & Mining
      Randstad UK Holding Limited,Professional Services
      Rank Group plc,Hotels, Restaurants & Leisure
      Ransomes Jacobsen Limited,Machinery
      Rapha Racing Ltd,Textiles, Apparel & Luxury Goods
      Rathbone Brothers Plc,Capital Markets
      Rathbone Brothers Plc,Capital Markets
      Ravago S.A,Trading Companies & Distributors
      Rawle Gammon & Baker Holdings Limited,Construction & Engineering
      Raymond Brown Construction Ltd,Construction & Engineering
      Raytheon Systems Limited,Electrical Equipment
      RCMA Group Pte Ltd,Trading Companies & Distributors
      RCUK Shared Services Centre Ltd,Professional Services
      RDI REIT PLC,Equity Real Estate Investment Trusts (REITs)
      Real Good Food plc,Food Products
      Rebellion Developments Ltd,Software
      Reckitt Benckiser Group PLC,Household Products
      Reconomy (UK) Ltd,Commercial Services & Supplies
      Red Bull,Beverages
      Red Commerce Limited (t/a Red SAP Solutions),Professional Services
      Red Funnel Ferries Limited,Marine
      Redburn (Europe) Limited,Capital Markets
      Redcentric plc,IT Services
      Redde plc,Road & Rail
      Redefine | BDL Hotels UK Ltd,Hotels, Restaurants & Leisure
      Redrock Consulting Ltd,Professional Services
      Redrow plc,Household Durables
      Reece Group Limited,Capital Markets
      Reed & Mackay Travel Limited,Hotels, Restaurants & Leisure
      Reed Smith LLP,Professional Services
      Reflex Group Ltd,Trading Companies & Distributors
      Regatta Ltd (t/a Regatta Great Outdoors),Textiles, Apparel & Luxury Goods
      Regent's University London,Diversified Consumer Services
      Reichle & De-Massari Holding AG,Electrical Equipment
      Reiss Ltd,Textiles, Apparel & Luxury Goods
      Rema Tip Top Holdings UK Limited,Capital Markets
      Remploy Limited,Commercial Services & Supplies
      RenaissanceRe Syndicate Management Limited,Professional Services
      Renault Truck Commercials Limited,Specialty Retail
      Renault Trucks SAS,Machinery
      Renault UK Limited,Specialty Retail
      Renewables Infrastructure Group (The) Ltd,Independent Power and Renewable Electricity Producers
      Renewi PLC,Commercial Services & Supplies
      Renishaw plc,Electronic Equipment, Instruments & Components
      Renold plc,Machinery
      Renrod Ltd (t/a Platinum Motor Group),Specialty Retail
      Rentokil Initial plc,Commercial Services & Supplies
      Repsol Sinopec Resources UK Limited,Oil, Gas & Consumable Fuels
      Research Triangle Institute (RTI),Professional Services
      Resource Solutions Group plc,Professional Services
      Restaurant Group plc (The),Hotels, Restaurants & Leisure
      Restore PLC,Commercial Services & Supplies
      ReThink Group (The),Professional Services
      Rettig UK Ltd,Distributors
      Reynolds Catering Supplies Ltd,Food & Staples Retailing
      Reynolds Porter Chamberlain LLP,Professional Services
      Rezidor Hotel Group,Hotels, Restaurants & Leisure
      RG Carter Construction Ltd,Construction & Engineering
      RH Smith & Sons (Wigmakers) Limited,Textiles, Apparel & Luxury Goods
      RHI Magnesita NV,Construction Materials
      Ribbon Acquisition Ltd,Hotels, Restaurants & Leisure
      Ricardo plc,Professional Services
      Richard Wellock and Sons Limited,Food & Staples Retailing
      Richer Sounds plc,Specialty Retail
      Rico Logistics Ltd,Air Freight & Logistics
      Ricoh Europe plc,Technology Hardware, Storage & Peripherals
      Rightmove PLC,Internet Software & Services
      Righton Limited,Distributors
      Ringway Jacobs Limited,Construction & Engineering
      Rio Tinto plc,Metals & Mining
      Riso Kagaku Corporation,Technology Hardware, Storage & Peripherals
      River and Mercantile Group plc,Capital Markets
      River Island Clothing Co. Limited,Specialty Retail
      Riverford Organic Farmers Ltd,Food Products
      Riverside Truck Rental Ltd,Road & Rail
      Rix Group,Construction & Engineering
      RM plc,Software
      Robert Bosch Limited,Electrical Equipment
      Robert Gordon University,Diversified Consumer Services
      Robert Half Limited,Professional Services
      Robert Walters Plc,Professional Services
      Robert Woodhead (Holdings) Ltd,Construction & Engineering
      Robertson Group Limited,Construction & Engineering
      Robinson Young Limited,Distributors
      ROCA Limited,Building Products
      Rocco Forte Hotels Limited,Hotels, Restaurants & Leisure
      Roche Products Limited,Pharmaceuticals
      Rockwell Automation Limited,Electrical Equipment
      Rockwell Collins,Aerospace & Defense
      Roevin Management Services Limited,Professional Services
      Rohde and Schwarz UK Limited,Communications Equipment
      ROHM Semiconductor GmbH,Semiconductors and Semiconductor Equipment
      Rolls-Royce Motor Cars Limited,Automobiles
      Rolls-Royce plc,Aerospace & Defense
      ROM Group Limited,Metals & Mining
      ROM Group Limited,Metals & Mining
      Rontec Roadside Retail Limited,Specialty Retail
      Roofoods Limited (t/a Deliveroo),Internet Software & Services
      Roquette Frères S.A,Food Products
      Ross-shire Engineering Ltd,Construction & Engineering
      Rotamat Ltd (t/a Huber Technology UK),Machinery
      Rotec Hydraulics Ltd,Trading Companies & Distributors
      Rothesay Life plc,Insurance
      Rothschild & Co Group,Capital Markets
      Rotork plc ,Machinery
      Rowan Companies plc,Energy Equipment & Services
      Royal Automobile Club Unlimited,Hotels, Restaurants & Leisure
      Royal Bank of Canada,Banks
      Royal Bank of Scotland Group plc (RBS),Banks
      Royal Bank of Scotland Group plc (RBS),Banks
      Royal Caribbean Cruises Ltd,Hotels, Restaurants & Leisure
      Royal Dutch Shell plc,Oil, Gas & Consumable Fuels
      Royal Holloway, University of London,Diversified Consumer Services
      Royal Institution of Chartered Surveyors,Professional Services
      Royal Liverpool and Broadgreen University Hospitals NHS Trust,Health Care Providers & Services
      Royal London Mutual Insurance Society Limited (The),Insurance
      Royal Mail plc,Air Freight & Logistics
      Royal Marsden (The) NHS Foundation Trust,Health Care Providers & Services
      Royal Veterinary College,Health Care Providers & Services
      Royds Withy King,Professional Services
      RPC Group plc,Containers & Packaging
      RPS Group plc,Commercial Services & Supplies
      RR Donnelley UK Limited,Commercial Services & Supplies
      RRG Group Ltd,Specialty Retail
      RSA Insurance Group plc,Insurance
      RSM UK Holdings Limited,Professional Services
      RSS (Wessex) Ltd (t/a The Rubicon Recruitment Group),Professional Services
      RTC Group plc,Professional Services
      Rubery Owen Holdings Ltd,Industrial Conglomerates
      Rubie's Masquerade Company (UK) Ltd,Textiles, Apparel & Luxury Goods
      Ruffer LLP,Capital Markets
      Ruia Group Ltd,Textiles, Apparel & Luxury Goods
      Rullion Ltd,Professional Services
      Russell Investments Limited,Capital Markets
      Russell Taylor Group Limited,Professional Services
      Russell's (Kirbymoorside) Limited,Distributors
      Russells Construction,Construction & Engineering
      RWC Partners Limited,Capital Markets
      RWE Supply & Trading GmbH,Independent Power and Renewable Electricity Producers
      RWG (Repair & Overhauls) Limited,Commercial Services & Supplies
      Rybrook Holdings Limited,Automobiles
      Rydon Group Limited,Construction & Engineering
      Rygor Commercial,Specialty Retail
      Ryness Electrical Supplies Ltd,Trading Companies & Distributors
      Ryohin Keikaku Co,Multiline Retail
      S. Norton & Co Limited,Metals & Mining
      S.A. Brain & Company Ltd,Beverages
      S&A Group Holdings Limited,Food Products
      S&B Herba Foods Ltd,Food & Staples Retailing
      SA Designer Parfums Limited,Household Products
      Saab Group,Aerospace & Defense
      SABIC (Saudi Basic Industries Corp),Chemicals
      SABMiller plc,Beverages
      Sabre Insurance Company Limited,Insurance
      SACO The Serviced Apartment Company Limited,Hotels, Restaurants & Leisure
      Safe Information Group NV,Commercial Services & Supplies
      SafeStyle UK PLC,Building Products
      Saga plc,Insurance
      Saga Services Limited (t/a Bennetts),Insurance
      Sage Group plc (The),Software
      SAGE Publishing UK ,Media
      Sainsbury's Bank plc,Banks
      Saint Gobain Group,Building Products
      Saipem spA,Energy Equipment & Services
      Salesforce.com,Software
      Salford Royal NHS Foundation Trust,Health Care Providers & Services
      Samsung Electronics (UK) Limited,Household Durables
      Samtec Inc,Electronic Equipment, Instruments & Components
      Sanderson Associates (Consulting Engineers) Ltd,Construction & Engineering
      Sandown Group,Specialty Retail
      Sandoz UK Ltd (part of Novartis AG),Pharmaceuticals
      Sanne Group PLC,Capital Markets
      Sanofi-Synthelabo UK Limited,Pharmaceuticals 
      Santander UK Group Holdings plc,Banks
      Sarasin & Partners LLP,Capital Markets
      SAS Software Limited,Software
      Satellite Information Services (Holdings) Limited Group,Media
      Savills plc,Real Estate Management & Development
      Saywell International Limited,Trading Companies & Distributors
      SC Johnson Europe Sarl,Household Products
      SCA Hygiene Products UK Ltd,Personal Products
      Scapa Group plc,Chemicals
      Scarab4 Ltd,Media
      Schenker Limited,Air Freight & Logistics
      Schindler Ltd,Machinery
      Scholastic Ltd,Media
      Schroders plc,Capital Markets
      Schueco UK Limited,Household Durables
      Science Group plc,Professional Services
      Scientific Laboratory Supplies Ltd,Electrical Equipment
      SCISYS plc,IT Services
      Scolmore Group,Electrical Equipment
      Scotbeef Ltd,Food, Beverage & Tobacco
      Scotland's Rural College,Diversifed Consumer Services
      Scott Trust Ltd (The),Media
      Scottish Leather Group Limited,Textiles, Apparel & Luxury Goods
      Scottish Power Limited,Electric Utilities
      Scottish Rugby Union plc,Media
      Scottish Sea Farms Ltd,Food Products
      Scottish Water Business Stream Limited,Water Utilities
      Scottish Water Ltd,Water Utilities
      Scottish Woodlands Ltd,Paper & Forest Products
      Screwfix Direct Limited,Specialty Retail
      SDC Builders Limited,Construction & Engineering
      SDL plc,Software
      Seaco Global Ltd,Trading Companies & Distributors
      Seafood Holdings Limited,Food & Staples Retailing
      Seafresh Group (Holdings) Limited,Diversified Financial Services
      Seajacks Ltd,Energy Equipment & Services
      Sealed Air Corporation,Containers & Packaging
      Seasalt Limited,Textiles, Apparel & Luxury Goods
      Seasalt Limited,Textiles, Apparel & Luxury Goods
      SEAT S.A,Automobiles
      Secom plc,Household Durables
      Secure Trust Bank plc,Banks
      Securigroup Limited,Capital Markets
      Securitas Security Services (UK) Limited,Commercial Services & Supplies
      Seetec Group Ltd,Professional Services
      Seewoo Group Limited,Diversified Financial Services
      SEGA Europe Limited,Software
      SEI Investments (Europe) Ltd,Capital Markets
      Seko Global Logistics Network LLC,Software
      Select Property Group (Holdings) Limited,Real Estate Management & Development
      Selfridges & Co Ltd,Multiline Retail
      Sellafield Ltd,Commercial Services & Supplies
      Sellick Partnership Limited,Professional Services
      Selwood Housing Society Ltd,Real Estate Management & Development
      Sembcorp Utilities (UK) Limited,Electric Utilities
      Senior plc,Aerospace & Defense
      Sennheiser Electronic GmbH & Co. KG,Electrical Equipment
      Sensient Technologies Corporation,Chemicals
      Sepura plc,Communications Equipment
      Serco Group plc,Commercial Services & Supplies
      Servelec Group PLC,Electronic Equipment, Instruments & Components
      Servest Group Ltd,Commercial Services & Supplies
      ServiceSource International,IT Services
      Servoca Plc,Professional Services
      Sevacare Holdings Limited,Health Care Providers & Services
      Seven Capital Plc,Capital Markets
      Severfield plc,Construction & Engineering
      Severn Trent plc,Water Utilities
      Severn Trent Services Ltd,Commercial Services & Supplies
      Sew-Eurodrive Limited,Machinery
      Sewell Group plc,Capital Markets
      SG Fleet Group Limited,Commercial Services & Supplies
      SGS United Kingdom Limited,Professional Services
      Shaftesbury PLC,Equity Real Estate Investment Trusts (REITs)
      Shakespeare Martineau LLP,Professional Services
      Shared Services Connected Ltd,Commercial Services & Supplies
      Sharp Electronics (Europe) Limited,Electronic Equipment, Instruments & Components
      Shaw Healthcare (Group) Limited,Health Care Providers & Services
      Shawbrook Bank Limited,Banks
      Shaylor Group plc,Construction & Engineering
      Shearings Leisure Group Limited,Hotels, Restaurants & Leisure
      Shearman & Sterling (London) LLP,Professional Services
      Sheffield Hallam UniversityåÊ,Diversifed Consumer Services
      Sheffield Health and Social Care NHS Foundation Trust ,Health Care Providers & Services
      Sheffield Teaching Hospitals NHS Foundation Trust,Health Care Providers & Services
      Shepherd and Wedderburn LLP,Professional Services
      Shepherd Neame Limited,Beverages
      Shepherds Bush Housing Group,Real Estate Management & Development
      Sherwin-Williams Diversified Brands Ltd,Chemicals
      Sherwood Business Support Limited,Professional Services
      Shimadzu Corporation,Electronic Equipment, Instruments & Components
      Shin-Etsu Handotai Europe Ltd,Electronic Equipment, Instruments & Components
      Shipowners' Club (The),Insurance
      Shire plc,Biotechnology
      Shiva Hotels Group LLP,Hotels, Restaurants & Leisure
      Shoosmiths LLP,Professional Services
      Shop Direct Group Ltd,Internet & Direct Marketing Retail
      Short Brothers plc,Aerospace & Defense
      Short Brothers Plc,Machinery
      Shropshire Community Health NHS Trust,Health Care Providers & Services
      Shropshire Group (G's) (The),Food Products
      Shurtape Technologies LLC,Chemicals
      Siemens Bank GmbH (London Branch),Banks
      Siemens Financial Services Ltd,Diversified Financial Services
      Siemens Gamesa Renewable Energy, S.A,Independent Power and Renewable Electricity Producers
      Siemens Healthcare Ltd,Health Care Technology
      Siemens Holdings plc,IT Services
      Siemens Industrial Turbomachinery Ltd,Electrical Equipment
      Siemens Industry Software Ltd,IT Services
      Siemens plc,Machinery
      Siemens Postal, Parcel and Airport Logistics Ltd,Air Freight & Logistics
      Siemens Protection Devices Ltd,Electrical Equipment
      Siemens Rail Automation Holdings Ltd,Road & Rail
      Siemens Transmission and Distribution Ltd,Electical Equipment
      SIG PLC,Trading Companies & Distributors
      Signature Flatbreads (UK) Ltd,Food Products
      Sika UK Ltd,Aerospace & Defense
      Silentnight Group Limited,Household Durables
      Silicon Valley Bank,Banks
      Sime Darby Berhad,Industrial Conglomerates
      Simmons & Simmons LLP,Professional Services
      Simons Group Ltd,Construction & Engineering
      Simplicity Marketing Limited,Internet Software & Services
      Simply Business Ltd,Insurance
      Simpson (York) Ltd,Construction & Engineering
      Simpsons Malt Limited,Food Products
      Sims Group UK Limited,Commercial Services & Supplies
      Siniat Ltd,Construction Materials
      Sir Robert McAlpine Limited,Construction & Engineering
      Sitec Group Limited,Construction & Engineering
      Siteimprove A/S,Internet Software & Services
      Sitel UK Ltd,Commercial Services & Supplies
      Six Degrees Holdings Limited,IT Services
      Skanska UK Plc,Construction & Engineering
      Skea Egg Farms Ltd,Food Products
      Skechers USA,Specialty Retail
      SKF (U.K.) Limited,Machinery
      Skipton Building Society,Thrifts & Mortgage Finance
      Sky Betting & Gaming Group,Hotels, Restaurants & Leisure
      Sky plc,Media
      Slater and Gordon (UK) LLP,Professional Services
      Slaughter and May,Professional Services
      Sleaford Quality Foods Limited,Food & Staples Retailing
      SLR Management Limited,Commercial Services & Supplies
      Smart Metering Systems Plc,Electronic Equipment, Instruments & Components
      Smart Systems Limited,Specialty Retail
      SmartestEnergy Ltd,Electric Utilities
      SMG Europe Holdings Limited,Hotels, Restaurants & Leisure
      Smith & Nephew plc,Health Care Equipment & Supplies
      Smith & Williamson Holdings Limited,Diversified Financial Services
      Smiths Group plc,Industrial Conglomerates
      Smiths Metal Centres Limited,Trading Companies & Distributors
      Smurfit Kappa Group plc,Containers & Packaging
      Smyths Toys UK Ltd,Specialty Retail
      Snap-On U.K. Holdings Limited,Specialty Retail
      SNC-Lavalin Rail and Transit Limited,Professional Services
      SOAS University of London,Diversified Consumer Services
      Societe Generale Equipment Finance Limited,Diversified Financial Services
      sociomantic labs GmbH,Internet Software & Services
      SOCO International plc,Oil, Gas & Consumable Fuels
      Sodexo Holdings Limited,Hotels, Restaurants & Leisure
      Sodick Europe Limited,Machinery
      Softcat plc,IT Services
      Software Box Limited,Electronic Equipment, Instruments & Components
      Solvay UK Holding Company Limited,Chemicals
      Solventis Ltd,Distributors
      Somerset Partnership NHS Foundation Trust,Health Care Providers & Services
      Sompo Japan Nipponkoa Insurance Company of Europe Limited,Insurance
      Sony Corporation,Household Durables
      Sony Group,Household Durables
      Sophos Group plc,Software
      Sophos Group plc ,Software
      Sophos Limited,Software
      Sopra Banking Software Limited,Software
      Sopra Steria Limited,IT Services
      Sotheby's,Diversified Consumer Services
      South East Water Limited,Water Utilities
      South Eastern Electrical Plc,Electric Utilities
      South Essex Partnership University NHS Foundation Trust,Health Care Providers & Services
      South Hook Gas Company Ltd,Oil, Gas & Consumable Fuels
      South Hook LNG Terminal Co Ltd,Oil, Gas & Consumable Fuels
      South Staffordshire PlcåÊ,Water Utilities
      South Tees Hospitals NHS Foundation Trusts,Health Care Providers & Services
      South Tyneside Council,Commercial Services & Supplies
      South Tyneside Nhs Foundation Trust,Health Care Providers & Services
      South32 Ltd,Metals & Mining
      Southampton Football Club Limited,Media
      Southampton Football Club Limited,Media
      Southampton Solent University (SSU),Diversified Consumer Services
      Southco Manufacturing Limited,Specialty Retail
      Southerly Communications Ltd,Electronic Equipment, Instruments & Components
      Southern Co-operative Limited (The),Food & Staples Retailing
      Southern Housing Group Limited,Real Estate Management & Development
      Southern Water Services Ltd,Water Utilities
      Southport  and  Ormskirk Hospital NHS Trust,Health Care Providers & Services
      Space Engineering Services Ltd,Construction & Engineering
      Spark Energy Ltd,Electric Utilities
      Sparrows Offshore Group Limited,Energy Equipment & Services
      Spearhead International Limited ,Food Products
      Specialist Computer Centres plc,IT Services
      Specialist People Services Group Ltd,Professional Services
      Specialized Bicycle Components Inc,Leisure Products
      Specsavers International Healthcare Limited ,Health Care Equipment & Supplies
      Spectris plc,Electronic Equipment, Instruments & Components
      Speedy Hire plc,Trading Companies & Distributors
      Spencer Ogden Ltd,Professional Services
      Spencer Stuart & Associates Limited,Professional Services
      SPI Lasers UK Ltd ,Electronic Equipment, Instruments & Components
      Spirax-Sarco Engineering plc,Machinery
      Spire Healthcare Group PLC,Health Care Providers & Services
      Spire Healthcare Limited,Health Care Providers & Services
      Spirent Communications Plc,Technology Hardware, Storage & Peripherals
      Spirit Aerosystems (Europe) Limited,Aerospace & Defense
      Splunk Services UK Limited,Software
      Sports Direct International plc,Specialty Retail
      Springer Nature,Media
      SQS Group Limited,Software
      Square Enix Holdings Co,Software
      Square Enix Ltd,Software
      Square One Resources Limited,Professional Services
      Squire Patton Boggs LLP,Professional Services
      SR Group UK Ltd,Professional Services
      SSE plc,Electric Utilities
      SSP Group plc,Hotels, Restaurants & Leisure
      SSP Limited,Hotels, Restaurants & Leisure
      St Austell Brewery Company Ltd,Beverages
      St Helens and Knowsley Teaching Hospitals NHS Trust,Health Care Providers & Services
      St Ives plc,Commercial Services & Supplies
      St John's College, Cambridge,Diversified Consumer Services
      St Jude Medical,Health Care Equipment & Supplies
      St Mary's Football Group Limited,Media
      St Mary's University, Twickenham,Diversified Consumer Services
      St. George's, University of London,Diversified Consumer Services
      St. James‰Ûªs Place Wealth Management Group,Capital Markets
      St. Modwen Properties PLC ,Real Estate Management & Development
      ST&H Limited (t/a Titan Travel),Hotels, Restaurants & Leisure
      Staffing Group,Professional Services
      Staffing Group Ltd,Professional Services
      Staffline Group plc,Professional Services
      Stagecoach Group plc,Road & Rail
      Stahlwille Tools Limited,Building Products
      Stallergenes Greer Plc,Pharmaceuticals
      Standard Bank London Holdings Limited,Banks
      Standard Chartered PLC,Banks
      Standard Life plc,Insurance
      Stanmore Quality Surfacing Limited,Multi-Utilities
      Stanton Bonna Concrete Limited,Construction Materials
      State Bank of India,Banks
      State Oil Limited,Specialty Retail
      State Street Corporation,Capital Markets
      Stateside Foods Ltd,Food Products
      Static Systems Group Plc,Communications Equipment
      Statkraft As,Independent Power and Renewable Electricity Producers
      Statoil ASA,Oil, Gas & Consumable Fuels
      Steelcase Inc,Commercial Services & Supplies
      Steer Davies Gleave Ltd,Professional Services
      Steinhoff UK Beds (t/a Slumberland Sleep Solutions),Specialty Retail
      Steinhoff UK Retail Limited (t/a Harveys Furniture),Specialty Retail
      Stemcor Global Holdings Ltd,Trading Companies & Distributors
      Stena Drilling Ltd,Oil, Gas & Consumable Fuels
      Stepan Company,Chemicals
      Stephenson Harwood LLP,Professional Services
      Stericycle,Commercial Services & Supplies
      Steris plc,Health Care Equipment & Supplies
      Stewarts Law LLP,Professional Services
      SThree plc,Professional Services
      Stifel Nicolaus Europe Limited,Capital Markets
      STIHL Inc,Household Durables
      Stobart Group Ltd ,Oil, Gas & Consumable Fuels
      Stone Computers Ltd,Technology Hardware, Storage & Peripherals
      Stonegate Pub Company Ltd,Hotels, Restaurants & Leisure
      Stora Enso,Paper & Forest Products
      Stork Technical Services (RBG) Limited,Professional Services
      Storm Technologies Limited,IT Services
      Story Contracting Limited,Construction & Engineering
      Story Homes Limited,Household Durables
      Strachans Limited,Food & Staples Retailing
      Strand Palace Hotel & Restaurants Ltd,Hotels, Restaurants & Leisure
      Strategic Team Maintenance.Co. Limited,Construction & Engineering
      Strathclyde Pharmaceuticals Limited,Pharmaceuticals 
      Streamline Shipping Group Ltd,Marine
      Structuretone International Limited,Construction & Engineering
      Strutt & Parker LLP,Real Estate Management & Development
      Studiocanal Limited,Media
      Study Group UK Limited,Diversified Consumer Services
      Styles&Wood Group plc,Commercial Services & Supplies
      Subsea 7 Ltd,Energy Equipment & Services
      SUEZ Recycling and Recovery UK Ltd,SUEZ Recycling and Recovery UK Ltd
      Sulzer Ltd,Machinery
      Suma Wholefoods,Food & Staples Retailing
      Sumika Polymer Compounds (Europe) Ltd,Chemicals
      Sumitomo Corporation Group,Trading Companies & Distributors
      Sumitomo Electric Europe Ltd,Electrical Equipment
      Sumitomo Electric Wiring Systems (Europe) Ltd,Auto Components
      Sumitomo Mitsui Banking Corporation Europe Limited,Banks
      Sun Life Assurance Company of Canada (U.K.) Limited,Insurance
      Sun Life Assurance Company of Canada (UK) Limited,Insurance
      Sun Mark Ltd,Food & Staples Retailing
      Sun Valley Limited,Food Products
      Sunderland Clinical Commissioning Group,Health Care Providers & Services
      Sunderland Limited,Media
      Sungard Availability Services (UK) Limited,IT Services
      SunOpta Inc,Food Products
      Sunovion Pharmaceuticals Europe Limited,Pharmaceuticals 
      Sunseeker International Limited,Leisure Products
      Suntory Beverage and Food Europe,Beverages
      SuperBreak Mini-Holidays Limited,Hotels, Restaurants & Leisure
      Superdrug Stores plc,Specialty Retail
      Superdry PLC,Specialty Retail
      SuperGroup plc,Specialty Retail
      Surrey Satellite Technology Limited,Aerospace & Defense
      Sutherland Global Services Inc,IT Services
      Sutton and East Surrey Water plc (t/a SES Water),Water Utilities
      Suttons Transport Group Ltd ,Air Freight & Logistics
      SUZUKI GB PLC,Specialty Retail
      SVM Global Ltd,Specialty Retail
      Swagelok Inc,Machinery
      Swan Mill Paper Company Limited,Paper & Forest Products
      Swansea City Association Football Club Limited,Media
      Swansea University,Diversified Consumer Services
      Swarovski Group,Textiles, Apparel & Luxury Goods
      Sweco UK Holding Limited,Professional Services
      Sweett Group plc,Professional Services
      Swift Group Ltd,Automobiles
      Swinton Group Limited,Insurance
      Swire Pacific Offshore Group,Marine
      Swiss Re Limited,Insurance
      Swissport GB Ltd,Transportation Infrastructure
      Sydenhams Ltd,Trading Companies & Distributors
      Sykes Enterprisesorporated,IT Services
      Symantec Corporation,Software
      Symington'S Limited,Food Products
      Symphony Group PLCåÊ(The),Household Durables
      Symphony Housing Group Ltd,Real Estate Management & Development
      Symrise Limited,Distributors
      Syndicate Bank,Banks
      Synectics plc,Electronic Equipment, Instruments & Components
      Synectics plc  ,Electronic Equipment, Instruments & Components
      Syngenta Limited,Chemicals
      Synlab Limited,Health Care Providers & Services
      Synnex-Concentrix UK Limited,Internet Software & Services
      Syntel Europe Limited,IT Services
      Synthomer plc,Chemicals
      Systech Group Limited,Professional Services
      Systra Limited,Professional Services
      T & B (Contractors) Limited,Construction & Engineering
      T-Systems Limited,IT Services
      T. C. Harrison Group Limited (t/a  icarlease),Specialty Retail
      T. Rowe Price International Ltd,Capital Markets
      T&K Gallagher Ltd,Construction & Engineering
      T&L Sugars Limited,Food Products
      Tailored Brands,Specialty Retail
      Takeda Development Centre Europe Ltd,Pharmaceuticals
      Takeda UK Limited,Pharmaceuticals 
      Talbot Underwriting Services Ltd,Professional Services
      TalkTalk Telecom Group PLC,Diversified Telecommunication Services
      Tandem Group Plc,Leisure Products
      Tangerine Confectionery Limited,Food Products
      Target Group Limited,Software
      Tata Chemicals Europe Holdings Limited,Chemicals
      Tata Communications (UK) Limited,Diversified Telecommunication Services
      Tata Global Beverages (UK) Limited,Food Products
      Tata Steel Europe Group,Metals & Mining
      Tata Technologies Europe Limited ,IT Services
      Tate & Lyle plc,Food Products
      Taylor Maxwell & Co. Ltd,Trading Companies & Distributors
      Taylor Wessing LLP,Professional Services
      Taylor Wimpey plc,Household DurablesFood & Staples Retailing
      Tayto Group Limited,Food Products
      Tazaki Foods Limited,Food & Staples Retailing
      Taziker Industrial Limited,Construction & Engineering
      TCC Global N.V,Professional Services
      TCI Fund Management Limited,Capital Markets
      TCL Holdings Limited,Real Estate Management & Development
      TClarke plc,Construction & Engineering
      TDX Group Limited,Software
      TE Connectivity Ltd,Electronic Equipment, Instruments & Components
      Teach First,Charity/Non-Profit
      TeamUltra,IT Services
      Tech Data Ltd,Electronic Equipment, Instruments & Components
      Tech Mahindra Limited,IT Services
      Technicolor Disc Services International Limited,Household Durables
      Technogym UK Limited,Leisure Products
      Technology Services Group Limited,IT Services
      TechTeam (UK) Limited,IT Services
      Ted Baker PlcåÊ,Textiles, Apparel & Luxury Goods
      Teesside University,Diversified Consumer Services
      Telecom Plus Plc,Multi-Utilities
      Teledyne Technologies Incorporated,Aerospace & Defense
      Telefonica UK Limited (O2),Telecommunication Services
      telent Technology Services Limited,IT Services
      Teleperformance Limited,Commercial Services & Supplies
      TeleTracking Technologies Inc,Health Care Technology
      Telford Homes plc,Household Durables
      Telstra Corporation Limited,Diversified Telecommunication Services
      Temenos Group AG,Software
      Templine Employment Agency Ltd,Professional Services
      Tenet Group Limited,Professional Services
      Tennants Consolidated Limited,Chemicals
      Tenneco-Walker (U.K.) Limited,Specialty Retail
      Tenpin Limited,Hotels, Restaurants & Leisure
      Terberg DTS (UK) Ltd,Trading Companies & Distributors
      Terex Corporation,Machinery
      Terex Equipment Limited,Machinery
      Terma A/S,Aerospace & Defense
      Tesco Mobile Limited,Diversified Telecommunication Services
      Tesco plc,Food & Staples Retailing
      Tetra Pak Limited,Containers & Packaging
      Teva UK Limted,Pharmaceuticals
      Texas Instruments Incorporated,Semiconductors & Semiconductor Equipment
      TFS Stores Limited,Consumer Durables & Apparel
      TGI Fridays Inc,Hotels, Restaurants & Leisure
      Thai Union Group plc,Food Products
      Thales UK LImited,Aerospace & Defense
      Thames Valley Housing Association Ltd,Real Estate Management & Development
      Thames Water Utilities Ltd,Water Utilities
      The Canada Life Group (U.K.) Limited,Insurance
      The Canada Life Group (UK) Limited,Insurance
      The Interpublic Group of Companies,Media
      The Press Association Group Ltd,Media
      The Quattro Group Limited,Machinery
      The Royal National Theatre,Diversified Consumer Services
      The Sterling Group, L.P,Capital Markets
      The Wrekin Housing Trust Limited,Real Estate Management & Development
      Theo Paphitis Retail GroupåÊ,Specialty Retail
      Thesis Asset Management,Capital Markets
      Thistle Seafoods Ltd,Food Products
      Thomas Armstrong (Holdings) Ltd,Construction Materials
      Thomas Cook Group plc,Hotels, Restaurants & Leisure
      Thomas Miller,Insurance
      Thomas Pink Ltd,Textiles, Apparel & Luxury Goods
      Thompson & Capper Limited ,Life Sciences Tools & Services
      Thornton Tomasetti Inc,Construction & Engineering
      Thorntons Limited,Food Products
      Thurlow Nunn (Holdings) Limited,Automobiles
      Thwaites Ltd,Machinery
      TI Fluid Systems PLC,Auto Components
      Tibbetts Group Ltd (The),Distributors
      Tiffin Sandwiches,Hotels, Restaurants & Leisure
      Tilda Ltd,Food & Staples Retailing
      Tillicoultry Quarries,Construction Materials
      Time Inc. UK,Media
      Timpson Ltd,Diversified Consumer Services
      Titan Airways Ltd,Airlines
      TLT Solicitors,Professional Services
      TNEI Services Ltd,Professional Services
      Together Housing Association (t/a Green Vale),Real Estate Management & Development
      Tokio MarineÂ HCC,Insurance
      Tolent Construction Limited,Construction
      Tolent Construction Limited,Construction & Engineering
      Toll Holdings Limited,Air Freight & Logistics
      TOMS Shoes LLC,Textiles, Apparel & Luxury Goods
      Topps Tiles PLC,Specialty Retail
      Topps Tiles plc,Specialty Retail
      Toro Co (The),Machinery
      Toshiba Group,Industrial Conglomerates
      Toshiba International (Europe) Ltd,Electrical Equipment
      Toshiba TEC UK Imaging Systems Ltd,Commercial Services & Supplies
      Total Foodservice Solutions Ltd,Food & Staples Retailing
      Total Polyfilm Group Limited,Chemicals
      Total Produce (UK) Limited,Food & Staples Retailing
      Total System Services,IT Services
      Total UK Limited,Oil, Gas & Consumable Fuels
      Tottenham Hotspur Football Club,Media
      Towergate Insurance Limited,Insurance
      Toyota (GB) PLC,Specialty Retail
      Toyota Financial Services (UK) PLC,Consumer Finance
      Toyota Material Handling UK,Machinery
      TP ICAP plc,Capital Markets
      TPG Europe,Capital Markets
      TRAC International Ltd,Construction & Engineering
      TRAC Intl. Ltd,Construction & Engineering
      Trafford Housing Trust Ltd,Real Estate Management & Development
      Transline Group,Media
      Transport for London (TfL),Road & Rail
      Travelex UK Limited,Consumer Finance
      Travers Smith LLP,Professional Services
      Travis Perkins Group,Trading Companies & Distributors
      Travis Perkins plc,Trading Companies & Distributors
      Treasury Wine Estates Limited,Beverages
      Treatt plc,Chemicals
      Trident Housing Association,Real Estate Management & Development
      Trifast plc,Building Products
      Trimble Inc,Electronic Equipment, Instruments & Components
      Trinity College London,Diversified Consumer Services
      Trinity Mirror plc,Media
      Trios Group Limited,Commercial Services & Supplies
      TripAdvisor Limited ,Internet & Direct Marketing Retail
      Triton Construction Ltd,Construction & Engineering
      Triumph Motorcycles Ltd,Automobiles
      Trowers & Hamlins LLP,Professional Services
      Troy Asset Management Limited,Capital Markets
      TRS Staffing Solutions,Professional Services
      TSB Bank plc,Banks
      TUI Group,Hotels, Restaurants & Leisure
      Tulip Ltd,Food Products
      Tullow Oil PLC,Oil, Gas & Consumable Fuels
      Tunstall Healthcare (UK) Ltd,Communications Equipment
      Turner & Co. (Glasgow) Ltd,Trading Companies & Distributors
      Turner & Townsend Limited,Construction & Engineering
      Tuskerdirect Limited ,Road & Rail
      Tutco Heating Solutions Group,Machinery
      TVS Supply Chains Solutions Limited,Air Freight & Logistics
      TWI Ltd,Professional Services
      Tyman plc,Building Products
      Tyne and Wear Passenger Transport Executive (t/a Nexus),Road & Rail
      Typhoo Tea Limited,Beverages
      Tyrrells Potato Crisps Limited ,Food Products
      U & I Group PLC ,Real Estate Management & Development
      Ubiqus UK Limited,Commercial Services & Supplies
      UBM plc,Media
      UBS AG London Branch,Capital Markets
      UBS Asset Management (UK) Limited,Capital Markets
      UBS Limited,Capital Markets
      UCAS Media Ltd,Media
      UK Asset Resolution Group,Thrifts & Mortgage Finance
      UK Green Investment Bank plc,Capital Markets
      UK P&I Club,Insurance
      UK Power Networks,Electric Utilities
      UK SBS Ltd,Professional Services
      Ultima Business Solutions Limited,IT Services
      Ultra Electronics Holdings plc,Aerospace & Defense
      Ultraframe (UK) Ltd,Building Products
      Umbrella Contracts Limited,Commercial Services & Supplies
      Unatrac Limited,Trading Companies & Distributors
      Under Armour Inc,Textiles, Apparel & Luxury Goods
      Unilever PLC,Personal Products
      Unipart Group of Companies Limited,Air Freight & Logistics
      Unit4 N.V,Software
      Unite Group plc,Equity Real Estate Investment Trusts (REITs)
      United Lincolnshire Hospitals NHS Trust ,Health Care Providers & Services
      United Molasses Group Ltd,Food & Staples Retailing
      United Utilities,Water Utilities
      UnitedHealthcare Global,Health Care Providers & Services
      Univar B.V,Trading Companies & Distributors
      UNIVEG UK Ltd,Food Products
      Universities Superannuation Scheme Limited,Capital Markets
      University College London,Diversified Consumer Services
      University Hospitals of Morecambe Bay NHS Foundation Trust,Health Care Providers & Services
      University of Aberdeen,Diversified Consumer Services
      University of Bath,Diversified Consumer Services
      University of Birmingham,Diversified Consumer Services
      University of Bolton,Diversified Consumer Services
      University of Bristol,Diversified Consumer Services
      University of Cambridge,Diversified Consumer Services
      University of Central Lancashire,Diversified Consumer Services
      University of Chichester,Diversified Consumer Services
      University of Cumbria,Diversified Consumer Services
      University of Dundee,Diversified Consumer Services
      University of East Anglia,Diversified Consumer Services
      University of East London,Diversified Consumer Services
      University of Edinburgh,Diversified Consumer Services
      University of Essex,Diversified Consumer Services
      University of Glasgow,Diversified Consumer Services
      University of Gloucestershire,Diversified Consumer Services
      University of Greenwich,Diversified Consumer Services
      University of Huddersfield,Diversified Consumer Services
      University of Hull,Diversified Consumer Services
      University of Kent,Diversified Consumer Services
      University of Leicester,Diversified Consumer Services
      University of Leicester,Diversified Consumer Services
      University of London,Diversified Consumer Services
      University of Manchester,Diversified Consumer Services
      University of Northampton,Diversified Consumer Services
      University of Nottingham,Diversified Consumer Services
      University of Oxford,Diversified Consumer Services
      University of Plymouth,Diversified Consumer Services
      University of Portsmouth,Diversified Consumer Services
      University of Reading,Diversified Consumer Services
      University of Roehampton,Diversified Consumer Services
      University of Salford Manchester,Diversified Consumer Services
      University of Sheffield,Diversified Consumer Services
      University of South Wales,Diversified Consumer Services
      University of St Andrews,Diversified Consumer Services
      University of Stirling,Diversified Consumer Services
      University of Strathclyde Glasgow,Diversified Consumer Services
      University of Suffolk,Diversified Consumer Services
      University of Surrey,Diversified Consumer Services
      University of Sussex,Diversified Consumer Services
      University of the Arts London (UAL),Diversified Consumer Services
      University of the Highlands and Islands,Diversified Consumer Services
      University of the West of England (UWE) Bristol,Diversified Consumer Services
      University of the West of Scotland,Diversified Consumer Services
      University of Warwick,Diversified Consumer Services
      University of Westminster,Diversified Consumer Services
      University of Wolverhampton,Diversified Consumer Services
      University of York,Diversified Consumer Services
      Unlimited Marketing Group Ltd,Media
      Unum Limited,Insurance
      UP Global Sourcing Holdings plc,Distributors
      UPM-Kymmene (UK) Ltd. ,Paper & Forest Products
      UPP Group Holdings Limited,Real Estate Management & Development
      UPS Limited,Air Freight & Logistics
      Urban Outfitters,Specialty Retail
      Urban&Civil plc,Real Estate Management & Development
      Urbanest UK Limited,Real Estate Management & Development
      Urbaser Ltd,Commercial Services & Supplies
      UST Global Private Limited,IT Services
      VA Tech (UK) Limited,Electrical Equipment
      VA TECH T & D UK Ltd,Electrical Equipment
      Valpak Limited,Commercial Services & Supplies
      Vanquis Bank Limited,Banks
      Vectura Group plc,Pharmaceuticals
      Vedanta Resources plc,Metals & Mining
      VEKA plc,Chemicals
      Velux Company Limited,Household Durables
      Venn Group Limited,Professional Services
      Verastar Ltd,Commercial Services & Supplies
      Verifone,Technology Hardware, Storage & Peripherals
      Vertas Group Limited,Commercial Services & Supplies
      Vertu Motors PLC,Specialty Retail
      Vestas Wind Systems A/S,Electrical Equipment
      Vesuvius plc,Machinery
      Vetter Pharma International GmbH,Health Care Providers & Services
      VF Corporation,Textiles, Apparel & Luxury Goods
      Viacom Inc,Media
      ViaSat Inc,Communications Equipment
      Vice Europe Holding Ltd,Media
      Victoria Plc,Household Durables
      Victrex plc,Chemicals
      Vifor Pharma Group ,Pharmaceuticals
      Vinci Construction UK Ltd,Construction & Engineering
      VINCI Energies UK Holding Ltd,Construction & Engineering
      Virgin Active Limited,Hotels, Restaurants & Leisure
      Virgin Atlantic Airways Limited,Airlines
      Virgin Care,Health Care Providers & Services
      Virgin Holidays Limited,Hotels, Restaurants & Leisure
      Virgin Money  Holdings (UK) plc,Banks
      Virtual Human Resources Limited,Professional Services
      Visa Inc,IT Services
      Vision Critical Communications Inc,Internet Software & Services
      Vision Express (UK) Limited,Specialty Retail
      Vital Recruitment Limited,Professional Services
      Vitec Group plc (The),Household Durables
      Vitol Services Ltd,Oil, Gas & Consumable Fuels
      VIVID Homes Limited,Real Estate Management & Development
      Vocare Group,Health Care Providers & Services
      Vodafone Group plc,Wireless Telecommunication Services
      voestalpine Metsec plc,Metals & Mining
      Vohkus Ltd,IT Services
      Volac International Limited,Food Products
      Volex plc,Electrical Equipment
      VolkerWessels UK Ltd,Construction & Engineering
      Volkswagen Group,Automobiles
      Volution Group plc,Building Products
      Volvo Car AB,Automobiles
      Volvo Group UK Limited,Machinery
      Voyage Care Ltd,Health Care Providers & Services
      Vp plc,Trading Companies & Distributors
      VTB Capital Plc,Capital Markets
      VUR Village Trading No 1 Limited ,Hotels, Restaurants & Leisure
      Vygon (UK) Ltd,Health Care Providers & Services
      W & J Linney Limited,Media
      W & R Barnett Limited,Food & Staples Retailing
      W. L. Gore & Associates,Chemicals
      W. Wing Yip & Brothers Trading Group Limited,Distributors
      W.N.Lindsay Ltd,Commercial Services & Supplies
      WÃ¼rth Elektronik Group,Electronic Equipment, Instruments & Components
      Wabtec Corporation,Machinery
      Wacker Chemie AG,Chemicals
      Wacoal EMEA Ltd,Textiles, Apparel & Luxury Goods
      Wagstaff Bros. Limited (t/a Wagstaff Group),Commercial Services & Supplies
      Wakefield and District Housing Limited (WDH),?Real Estate Management & Development
      Wales & West Utilities Limited ,Gas Utilities
      Walgreens Boots Alliance,Food & Staples Retailing
      Walker Construction (UK) Limited,Construction & Engineering
      Walker Greenbank Plc,Household Durables
      Walker Morris LLP,Professional Services
      Walkers Shortbread Limited,Food Products
      Walney (UK) Offshore Windfarms Ltd,Independent Power and Renewable Electricity Producers
      Walsall College,Diversified Consumer Services
      Walsall Housing Group Limited,Real Estate Management & Development
      Walt Disney Company Ltd (The),Media
      Walter Scott & Partners Limited,Capital Markets
      Wandle Housing Association Ltd,Real Estate Management & Development
      Warburg Pincus LLC,Capital Markets
      Warburtons Limited,Food Products
      Warehouse Express Ltd,Specialty Retail
      Warrington and Halton Hospitals NHS Foundation Trust,Health Care Providers & Services
      Warwickshire College Group (WCG),Diversified Consumer Services
      Wasabi Co. Ltd,Hotels, Restaurants & Leisure
      Wasdell Group,Health Care Providers & Services
      Wastecycle Limited,Commercial Services & Supplies
      Watchstone Group Plc,IT Services
      Waterline Limited,Distributors
      Waterman Group plc,Professional Services
      Waters Corporation,Life Sciences Tools & Services
      Waterstones Booksellers Limited,Specialty Retail
      Wates Group Limited,Construction & Engineering
      Wates Group Ltd,Construction & Engineering
      Watford Association Football Club LimitedåÊ,Media
      WCF Ltd,Distributors
      WD Meats Ltd,Food Products
      WD-40 Company Limited,Chemicals
      WDFC UK Limited (t/a Wonga),Consumer Finance
      WDFG UK Limited,Specialty Retail
      Wealmoor Ltd,Food Products
      Weatherford International plc,Energy Equipment & Services
      Web Oil Limited,Oil, Gas & Consumable Fuels
      Webhelp Management Service (Uk) Limited,IT Services
      Weetabix Limited,Food Products
      Weightmans LLP,Professional Services
      Weir Group PLC,Machinery
      Welding Alloys Ltd,Metals & Mining
      Wellcome Trust Ltd,Commercial Services & Supplies
      Welsh Rugby Union Limited (The),Hotels, Restaurants & Leisure
      Welspun Home Textiles UK Ltd. ,Distributors
      Welton Bibby & Baron Limited,Containers & Packaging
      Wernick Group (Holdings) Limited,Machinery
      Wesfarmers Limited,Food & Staples Retailing
      Wessanen UK,Food Products
      Wessex Water Services Ltd,Water Utilities
      West Bromwich Building Society,Thrifts & Mortgage Finance
      West Kent Housing Association,Real Estate Management & Development
      West Norfolk Clinical Commissioning Group,Health Care Providers & Services
      West Nottinghamshire College,Diversified Consumer Services
      West Pharmaceutical Services,Health Care Equipment & Supplies
      Westbridge Furniture Designs Ltd,Household Durables
      Westermost Rough Limited,Independent Power and Renewable Electricity Producers
      Western Asset Management Company Ltd,Capital Markets
      Western Power Distribution plc,Electric Utilities
      Westfield Corporation Limited,Real Estate Management & Development
      Westleigh Partnerships Ltd,Household Durables
      Westmill Foods Ltd,Food & Staples Retailing
      Westminster Group Plc,Electronic Equipment, Instruments & Components
      Westmorland Ltd,Real Estate
      Westpac Banking Corporation,Banks
      Westpile Limited,Construction & Engineering
      Westridge Construction Ltd,Construction & Engineering
      WEX Europe Services Limited ,IT Services
      WFW Global LLP,Professional Services
      WGC Limited,Commercial Services & Supplies
      WH Smith Plc ,Specialty Retail
      Wheatley Housing Group Ltd,Real Estate Management & Development
      Whirlpool UK Appliances Limited ,Household Durables
      Whistl UK Ltd,Air Freight & Logistics
      Whistles Limited,Textiles, Apparel & Luxury Goods
      Whitbread plc,Hotels, Restaurants & Leisure
      Whitby Seafoods Ltd,Food Products
      White Stuff Ltd,Specialty Retail
      Whitecode Group Ltd,Commercial Services & Supplies
      Whitelink Seafoods Ltd,Food Products
      Wienerberger Ltd,Construction Materials
      Wightlink Limited,Marine
      Wildgoose Construction Ltd,Construction & Engineering
      Wiliams Lea Tag Group,IT Services
      Wilkin & Sons Limited,Food Products
      Wilkins Kennedy LLP,Professional Services
      Wilko Retail Limited,Specialty Retail
      William Hare Group Limited,Metals & Mining
      William Hill PLC,William Hill PLC
      William Lamb Group Limited,Textiles, Apparel & Luxury Goods
      William Tracey Limited,Commercial Services & Supplies
      Williams Lea & Tag Gmbh,Professional Services? - Commercial Services & Supplies?
      Williams Lea Limited,Commercial Services & Supplies
      Williamson-Dickie Europe Limited,Textiles, Apparel & Luxury Goods
      Willmott Dixon Group,Construction & Engineering
      Wilmer Cutler Pickering Hale and Dorr LLP,Professional Services
      Wilmington plc,Professional Services
      Wilson James Ltd,Commercial Services & Supplies
      Wincanton plc,Air Freight & Logistics
      Winchester Growers Ltd,Food Products
      Winckworth Sherwood LLP,Professional Services
      Winterbotham Darby & Co Ltd,Food Products
      Winton Group Limited,Capital Markets
      Winvic Construction Limited,Construction & Engineering
      Wipro Limited,IT Services
      Wirral University Teaching Hospital NHS Foundation Trust,Diversified Consumer Services
      Withers & Rogers Group LLP,Professional Services
      Withers LLP,Professional Services
      Witherslack Group,Diversified Consumer Services
      Withy King LLP,Professional Services
      WJ Group Ltd,Construction & Engineering
      WM Housing Group Ltd,Household Durables
      Wm Morrison Supermarkets plc,Food & Staples Retailing
      wnDirect Limited,Air Freight & Logistics
      WNS Global Services UK Ltd,Commercial Services & Supplies
      Wockhardt UK,Pharmaceuticals
      Wogen Resources Limited,Metals & Mining
      Wolseley UK Limited,Trading Companies & Distributors
      Woodford Investment Management Ltd,Capital Markets
      Woodside Haulage (Holdings) Limited,Road & Rail
      Worcester Carsales (Holdings) Ltd,Retailing
      World Gold Council,Commercial Services & Supplies
      World Travel Centre (t/a Selective Travel Management),Hotels, Restaurants & Leisure
      Worldpay Group plc,IT Services
      WorldVentures Marketing,Hotels, Restaurants & Leisure
      Worldwide Fruit Ltd,Distributors
      WPP plc,Media
      Wrap Film Systems Ltd,Containers & Packaging
      Wrexham GlyndÅµr University,Diversifed Consumer Services
      WS Atkins plc,Professional Services
      Wsh Investments Limited,Hotels, Restaurants & Leisure
      WSP UK Limited,Construction & Engineering
      WT Parker Group Services Limited,Construction & Engineering
      Wurth UK Limited,Distributors
      WYG plc ,Construction & Engineering
      Wyke Farms Ltd,Food Products
      Wyndham Worldwide Corporation,Hotels, Restaurants & Leisure
      Wynnstay Group PLC,Food Products
      Xafinity plc,Insurance
      Xeretec Group Ltd,Technology Hardware, Storage & Peripherals
      Xilinx Inc,Semiconductors & Semiconductor Equipment
      Xoserve Ltd,Energy Equipment & Services
      Xtratherm UK Ltd,Building Products
      Yamaha Music Europe GmbH,Specialty Retail
      Yamaha Music Europe GmbH,Specialty Retail
      Yamaha Music Europe Gmbh (UK),Specialty Retail
      Yamazaki Mazak UK Ltd,Machinery
      Yara UK Limited,Chemicals
      Yaskawa Electric Corporation,Electronic Equipment, Instruments & Components
      Yazaki Corporation,Auto Components
      Yearsley Group Limited,Commercial Services & Supplies
      Yeo Valley Farms (Production) Limited,Food Products
      Yo! Sushi Limited,Hotels, Restaurants & Leisure
      Yodel Delivery Network Limited,Air Freight & Logistics
      YOOX NET-A-PORTER GROUP ,Internet & Direct Marketing Retail
      York St John University,Diversified Consumer Services
      York Teaching Hospital NHS Foundation Trust,Health Care Providers & Services
      Yorkshire Building Society,Thrifts & Mortgage Finance
      Yorkshire Water Services Ltd,Water Utilities
      Yorwaste Limited,Commercial Services & Supplies
      YouGov plc,Media
      Young & Co.â€™s Brewery plc,Beverages
      Young's Seafood Limited,Food Products
      Your Electrical Supplies Service & Solutions A Ltd (t/a YESSS Electrical),Household Durables
      Your World Recruitment Group,Professional Services
      Zalando SE,Internet & Direct Marketing Retail
      Zenith Vehicle Contracts Group Limited,Commercial Services & Supplies
      Zenith Vehicle Contracts Limited ,Commercial Services & Supplies
      Zodiac Seats UK Limited,Aerospace & Defense
      Zoetis UK Ltd,Pharmaceuticals
      Zotefoams plc ,Chemicals
      ZPG Plc,Internet Software & Services
      ZPG Plc Zoopla,Internet Software & Services
      ZS Associates International,Professional Services
      Zumtobel Group AG,Electrical Equipment
      Zurich Insurance Group AG,Insurance}
  end
end
