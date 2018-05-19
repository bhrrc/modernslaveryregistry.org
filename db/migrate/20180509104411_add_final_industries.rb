class AddFinalIndustries < ActiveRecord::Migration[5.0]
  def up
    spreadsheet_data.split("\n").each do |line|
      line =~ /^\s*(\d+)\s*(.+)\s*$/
      company_id = $1
      industry_name = $2
      set_company_industry(company_id, industry_name)
    end
  end

  def set_company_industry(company_id, industry_name)
    puts "Updating '#{company_id}' to '#{industry_name}'..."
    company = Company.find(company_id)
    company.update!(industry: find_industry(industry_name))
    puts "Updated '#{company_id}' to '#{industry_name}'"
  rescue => e
    puts "Failed to update '#{company_id}' to '#{industry_name}'"
  end

  def find_industry(name)
    industry = Industry.find_by(name: name)
    raise "no industry with name '#{name}'" unless industry
    industry
  end

  def spreadsheet_data
%{17506	Consumer Finance
8986	Commercial Services & Supplies
6883	Distributors
6884	Capital Markets
6884	Capital Markets
9861	Chemicals
9966	Health Care Providers & Services
9735	Construction & Engineering
9397	Real Estate Management & Development
6887	Health Care Providers & Services
6887	Health Care Providers & Services
9753	Food Products
17312	Metals & Mining
8505	Diversified Consumer Services
18478	Aerospace & Defense
9987	Media
6888	Distributors
6889	Professional Services
16948	Household Durables
10948	Charity/Non-Profit
16754	Road & Rail
6890	Electrical Equipment
6890	Electrical Equipment
9970	Biotechnology
6891	Biotechnology
8506	Construction & Engineering
10172	Banks
17130	Internet & Direct Marketing Retail
9857	Road & Rail
6892	Road & Rail
9255	Diversified Consumer Services
9255	Diversified Consumer Services
6885	Machinery
8968	Media
6893	Beverages
17350	Food Products
17350	Food Products
6894	Commercial Services & Supplies
18332	Food Products
6895	Electronic Equipment, Instruments & Components
6895	Electronic Equipment, Instruments & Components
6896	Electronic Equipment, Instruments & Components
6896	Electronic Equipment, Instruments & Components
10911	Charity/Non-Profit
10911	Charity/Non-Profit
6897	Professional Services
6897	Professional Services
18008	Electronic Equipment, Instruments & Components
8507	Software
16783	Insurance
17785	Beverages
6898	Charity/Non-Profit
10796	Pharmaceuticals
9383	Health Care Providers & Services
10436	Household Products
17132	Paper & Forest Products
16784	Banks
18225	Technology Hardware, Storage & Peripherals
10874	Construction Materials
17508	Charity/Non-Profit
9455	Internet Software & Services
17133	Media
6899	Real Estate Management & Development
18039	Health Care Equipment & Supplies
9633	Diversified Consumer Services
16686	Energy Equipment & Services
10890	Charity/Non-Profit
10453	Capital Markets
16752	Diversified Consumer Services
17965	Software
8508	Software
8508	Software
6901	Leisure Products
6902	Real Estate Management & Development
6903	Professional Services
8980	Media
6904	Charity/Non-Profit
6904	Charity/Non-Profit
6905	Professional Services
6906	Food Products
18097	Professional Services
16949	Food Products
17509	Machinery
9357	Leisure Products
10484	Commercial Services & Supplies
8809	Media
9158	Insurance
6907	Hotels, Restaurants & Leisure
9123	Beverages
16908	IT Services
6908	Software
6909	IT Services
9440	Software
18454	Chemicals
16838	Health Care Equipment & Supplies
6912	Professional Services
6913	Air Freight & Logistics
6910	Charity/Non-Profit
6910	Charity/Non-Profit
8509	Marine
9736	Professional Services
17662	Media
16839	Professional Services
17857	Capital Markets
18507	Professional Services
16635	Construction & Engineering
9144	Insurance
9302	Capital Markets
10947	Independent Power and Renewable Electricity Producers
8920	Machinery
8921	Machinery
9079	Oil, Gas & Consumable Fuels
17135	Construction & Engineering
10719	Food & Staples Retailing
6914	Media
6915	Machinery
10960	Media
10010	Water Utilities
6916	Real Estate Management & Development
16950	Charity/Non-Profit
9427	Water Utilities
17695	Specialty Retail
17877	Marine
6917	Beverages
6919	Chemicals
9318	Insurance
6920	Specialty Retail
9571	Health Care Technology
9192	Construction Materials
9166	Commercial Services & Supplies
10243	Electrical Equipment
9787	IT Services
9787	IT Services
7493	Distributors
6918	Specialty Retail
6921	Transportation Infrastructure
6921	Transportation Infrastructure
6922	Food & Staples Retailing
10176	Banks
18327	Banks
17113	Banks
18305	Commercial Services & Supplies
8807	Insurance
10423	Insurance
16951	Food Products
6923	Health Care Providers & Services
18181	Insurance
9388	Aerospace & Defense
16785	Airlines
6924	Aerospace & Defense
16954	Air Freight & Logistics
17137	Chemicals
6925	Electrical Equipment
9524	Public Entities
9662	Airlines
9768	Chemicals
17138	Professional Services
6926	Textiles, Apparel & Luxury Goods
10508	IT Services
18306	Metals & Mining
6886	Food Products
18226	Aerospace & Defense
8510	Energy Equipment & Services
10662	Metals & Mining
18251	Food Products
6927	Professional Services
6928	Chemicals
17941	Machinery
17930	Machinery
7724	Food Products
6929	Commercial Services & Supplies
10332	Machinery
17942	Chemicals
6930	Food Products
17697	Capital Markets
10342	Diversified Consumer Services
8511	Energy Equipment & Services
6931	Banks
6931	Banks
8871	Food & Staples Retailing
9619	Diversified Financial Services
18098	Machinery
10940	Professional Services
9577	Internet Software & Services
9577	Internet Software & Services
16840	Machinery
6932	Hotels, Restaurants & Leisure
6933	Textiles, Apparel & Luxury Goods
6933	Textiles, Apparel & Luxury Goods
18330	Metals & Mining
17510	Semiconductors & Semiconductor Equipment
17780	Hotels, Restaurants & Leisure
9000	Professional Services
9453	Professional Services
9453	Professional Services
10365	Pharmaceuticals
18190	Distributors
17139	Capital Markets
6934	Charity/Non-Profit
9167	Health Care Providers & Services
9168	Pharmaceuticals
8743	Insurance
6935	Health Care Providers & Services
9149	Banks
6936	Food Products
6936	Food Products
6937	Professional Services
6937	Professional Services
6938	Health Care Technology
6939	Air Freight & Logistics
6939	Air Freight & Logistics
9581	Specialty Retail
16955	Real Estate Management & Development
17141	IT Services
8813	Insurance
16761	Trading Companies & Distributors
10809	Life Sciences Tools & Services
17698	Road & Rail
6940	Distributors
17345	Containers & Packaging
6941	Electrical Equipment
6942	Machinery
6943	Charity/Non-Profit
18256	Diversified Telecommunication Services
17142	Commercial Services & Supplies
8512	Electronic Equipment, Instruments & Components
6944	Building Products
10044	Real Estate Management & Development
6945	Building Products
6945	Building Products
6946	Construction & Engineering
17144	Commercial Services & Supplies
6947	Charity/Non-Profit
17403	Professional Services
9393	Machinery
8513	Construction & Engineering
10500	Metals & Mining
9476	Trading Companies & Distributors
10087	Internet & Direct Marketing Retail
17989	Hotels, Restaurants & Leisure
9909	Professional Services
6949	Professional Services
9514	Containers & Packaging
6950	Machinery
6951	Energy Equipment & Services
6951	Energy Equipment & Services
6952	Communications Equipment
6952	Communications Equipment
10099	Airlines
17931	Textiles, Apparel & Luxury Goods
10621	Diversified Financial Services
16684	Health Care Providers & Services
9445	Oil, Gas & Consumable Fuels
18328	Leisure Products
9486	Electrical Equipment
10466	Transportation Infrastructure
6953	Metals & Mining
16811	Metals & Mining
8514	Metals & Mining
8514	Metals & Mining
16698	Biotechnology
8697	Diversified Financial Services
6954	Real Estate Management & Development
17145	Banks
9106	Charity/Non-Profit
17511	Capital Markets
6955	Hotels, Restaurants & Leisure
9248	Electronic Equipment, Instruments & Components
10916	Building Products
18011	Insurance
6956	Insurance
8827	Airlines
8827	Airlines
9249	Semiconductors & Semiconductor Equipment
10896	Professional Services
10429	Pharmaceuticals
16615	Construction & Engineering
10769	Road & Rail
6957	Electronic Equipment, Instruments & Components
6958	Food Products
10121	Health Care Providers & Services
6959	Water Utilities
6960	Building Products
9252	Diversified Consumer Services
9835	Metals & Mining
9485	Food Products
6961	Food Products
10946	Beverages
17512	Electronic Equipment, Instruments & Components
6962	Commercial Services & Supplies
6963	IT Services
17909	Specialty Retail
6965	Electrical Equipment
6965	Electrical Equipment
6964	Distributors
6964	Distributors
18099	Software
17513	Hotels, Restaurants & Leisure
6966	Metals & Mining
9927	Construction & Engineering
6967	Banks
8900	Insurance
6969	Pharmaceuticals
6968	Internet & Direct Marketing Retail
6968	Internet & Direct Marketing Retail
16637	Oil, Gas & Consumable Fuels
9414	Capital Markets
8515	Commercial Services & Supplies
17147	Food Products
10372	Marine
9206	Paper & Forest Products
9588	Insurance
9588	Insurance
6971	Professional Services
10427	IT Services
17470	Food & Staples Retailing
18385	Technology Hardware, Storage & Peripherals
18513	Capital Markets
9593	Commercial Services & Supplies
16892	Food Products
18524	Software
6972	Charity/Non-Profit
9693	Software
18280	Health Care Providers & Services
18342	Construction & Engineering
18541	Diversified Financial Services
8517	Hotels, Restaurants & Leisure
8517	Hotels, Restaurants & Leisure
6973	Air Freight & Logistics
8518	Professional Services
18068	Paper & Forest Products
17404	Banks
6974	Specialty Retail
9431	Professional Services
9431	Professional Services
10357	Metals & Mining
10917	Media
10397	Food Products
17514	Distributors
16841	Capital Markets
6975	Commercial Services & Supplies
16700	Containers & Packaging
17148	Trading Companies & Distributors
17331	Food & Staples Retailing
17331	Food & Staples Retailing
17801	Capital Markets
10949	Food Products
6976	Food Products
17405	Insurance
6977	Media
6977	Media
16958	Road & Rail
10628	Specialty Retail
6978	Specialty Retail
9460	Paper & Forest Products
9386	Real Estate Management & Development
6979	Media
6979	Media
10937	Metals & Mining
6980	Building Products
18211	Building Products
17984	Air Freight & Logistics
6981	Road & Rail
6982	Electronic Equipment, Instruments & Components
18150	Diversified Financial Services
9517	Capital Markets
6983	Road & Rail
6984	Media
6984	Media
9518	Capital Markets
18052	Insurance
18069	Construction & Engineering
6985	Hotels, Restaurants & Leisure
9529	Professional Services
9921	Diversified Consumer Services
6986	Professional Services
8883	Specialty Retail
6987	IT Services
6988	Professional Services
9140	Media
17966	Chemicals
6989	Energy Equipment & Services
6990	Insurance
9294	Food & Staples Retailing
9472	Machinery
9472	Machinery
6991	Health Care Providers & Services
9169	Capital Markets
6992	Trading Companies & Distributors
6993	Professional Services
6993	Professional Services
10669	Textiles, Apparel & Luxury Goods
6994	Semiconductors & Semiconductor Equipment
6995	Internet & Direct Marketing Retail
6995	Internet & Direct Marketing Retail
18227	Capital Markets
10458	Insurance
18499	Machinery
6996	Hotels, Restaurants & Leisure
6996	Hotels, Restaurants & Leisure
9682	Construction & Engineering
10306	Construction & Engineering
6997	Real Estate Management & Development
6997	Real Estate Management & Development
10688	Diversified Financial Services
9656	Professional Services
6998	Food Products
6998	Food Products
9306	Transportation Infrastructure
9028	Insurance
6999	Equity Real Estate Investment Trusts (REITs)
10570	Construction & Engineering
9391	Professional Services
7000	Pharmaceuticals
7000	Pharmaceuticals
17382	Pharmaceuticals
10850	Construction & Engineering
7001	Beverages
9273	Diversified Consumer Services
17929	Media
8519	Pharmaceuticals
8519	Pharmaceuticals
7002	Professional Services
9807	Technology Hardware, Storage & Peripherals
16875	Professional Services
16891	Metals & Mining
17515	Machinery
7003	Aerospace & Defense
10810	Pharmaceuticals
9714	IT Services
7004	Hotels, Restaurants & Leisure
9211	Insurance
10089	Specialty Retail
10324	Charity/Non-Profit
9538	Automobiles
16636	Household Durables
9019	Commercial Services & Supplies
8520	Machinery
7006	IT Services
7007	Specialty Retail
7007	Specialty Retail
16959	Beverages
17406	Charity/Non-Profit
18260	Software
16701	Auto Components
17134	Professional Services
9346	Insurance
9839	Auto Components
7008	Internet Software & Services
8828	IT Services
17516	Household Durables
8521	Software
17151	Capital Markets
7009	Containers & Packaging
10215	Health Care Providers & Services
7010	Software
10289	Media
9515	Food Products
10595	Professional Services
10469	Specialty Retail
8941	Insurance
9897	Auto Components
7012	Electronic Equipment, Instruments & Components
18543	Specialty Retail
10080	Public Entities
10134	Health Care Providers & Services
16936	Personal Products
8742	Aerospace & Defense
17701	Electronic Equipment, Instruments & Components
17140	Insurance
17497	Capital Markets
7013	Chemicals
9133	Insurance
7014	IT Services
7015	Commercial Services & Supplies
18247	Commercial Services & Supplies
16638	Insurance
10483	Auto Components
17517	Distributors
7016	Hotels, Restaurants & Leisure
7018	Commercial Services & Supplies
7018	Commercial Services & Supplies
16960	Electrical Equipment
7019	Beverages
10827	Pharmaceuticals
17633	Construction & Engineering
7020	Software
18101	Professional Services
8942	Aerospace & Defense
8942	Aerospace & Defense
8873	Construction & Engineering
18553	Wireless Telecommunication Services
7021	Capital Markets
7021	Capital Markets
10609	Capital Markets
7022	Professional Services
8316	Specialty Retail
17852	Diversified Financial Services
10551	Food Products
7023	Construction & Engineering
7023	Construction & Engineering
7024	Industrial Conglomerates
8731	Construction & Engineering
8853	Construction & Engineering
7025	Leisure Products
7026	Household Durables
9266	Diversified Consumer Services
7027	Food Products
10183	Banks
9370	Banks
7028	Banks
18194	Banks
10185	Banks
10175	Banks
17548	Banks
10170	Banks
10169	Banks
8754	Banks
7029	Banks
10178	Banks
8992	Banks
17787	Banks
18475	Construction & Engineering
18503	Hotels, Restaurants & Leisure
17634	Commercial Services & Supplies
7030	Trading Companies & Distributors
16702	Insurance
18336	Health Care Providers & Services
7031	Banks
7031	Banks
10084	Pharmaceuticals
7032	Construction & Engineering
8930	Food & Staples Retailing
8858	Food Products
16703	Food Products
17154	Food & Staples Retailing
7033	Construction & Engineering
7033	Construction & Engineering
9694	Capital Markets
7034	Commercial Services & Supplies
7034	Commercial Services & Supplies
10144	Health Care Providers & Services
7035	Charity/Non-Profit
17938	Machinery
10857	Construction & Engineering
7036	Capital Markets
7036	Capital Markets
17899	Construction & Engineering
7037	Diversified Consumer Services
7037	Diversified Consumer Services
7038	Household Durables
7038	Household Durables
10425	Specialty Retail
10691	Metals & Mining
7039	Hotels, Restaurants & Leisure
9688	Food Products
17518	Distributors
16961	Media
7040	Diversified Financial Services
10106	Health Care Providers & Services
7041	Commercial Services & Supplies
9057	Chemicals
7042	Diversified Consumer Services
10903	Media
7043	Health Care Equipment & Supplies
7044	Electrical Equipment
7045	Health Care Equipment & Supplies
18262	Health Care Equipment & Supplies
9417	Food Products
17383	Commercial Services & Supplies
18535	Industrial Conglomerates
10817	Pharmaceuticals
18373	Banks
17344	Household Products
8326	Construction & Engineering
7046	Transportation Infrastructure
10021	Charity/Non-Profit
7047	Media
7047	Media
7017	Health Care Equipment & Supplies
9546	Professional Services
10725	Specialty Retail
8978	Construction & Engineering
10586	Construction & Engineering
7048	Diversified Financial Services
7049	Professional Services
10598	Diversified Financial Services
7050	Leisure Products
7051	Professional Services
10887	Professional Services
7052	Beverages
18403	Chemicals
16786	Specialty Retail
7053	Professional Services
18193	Health Care Equipment & Supplies
8909	Insurance
9080	Construction & Engineering
10489	Food Products
10355	Commercial Services & Supplies
18329	Health Care Equipment & Supplies
17407	Health Care Equipment & Supplies
18529	Hotels, Restaurants & Leisure
18505	Hotels, Restaurants & Leisure
17408	Household Durables
9583	Food Products
7054	Distributors
8791	Professional Services
9077	Household Products
7055	Public Entities
7056	Household Durables
10277	Household Products
7057	Specialty Retail
9171	Household Durables
9171	Household Durables
16654	Hotels, Restaurants & Leisure
17704	Commercial Services & Supplies
18252	Diversified Consumer Services
10944	Food & Staples Retailing
17520	Containers & Packaging
18070	Distributors
7058	Household Durables
7059	Specialty Retail
8749	Auto Components
17106	Automobiles
18468	Software
17156	Hotels, Restaurants & Leisure
9172	Commercial Services & Supplies
9172	Commercial Services & Supplies
7060	Household Durables
10588	Insurance
9944	Health Care Providers & Services
17409	Food Products
16842	Real Estate Management & Development
17703	Beverages
7061	Food & Staples Retailing
17824	Professional Services
16705	Media
7062	Professional Services
7062	Professional Services
16687	Health Care Equipment & Supplies
7063	Textiles, Apparel & Luxury Goods
7063	Textiles, Apparel & Luxury Goods
9841	Industrial Conglomerates
16857	Food & Staples Retailing
9852	Food & Staples Retailing
9852	Food & Staples Retailing
7064	Food Products
7065	Professional Services
10347	Electronic Equipment, Instruments & Components
7066	Food & Staples Retailing
18571	Capital Markets
7067	Marine
9701	Insurance
7068	Metals & Mining
7068	Metals & Mining
9390	Air Freight & Logistics
9374	Diversified Financial Services
16963	Industrial Conglomerates
16964	Beverages
7070	Real Estate Management & Development
9031	Commercial Services & Supplies
7071	Diversified Consumer Services
17670	Energy Equipment & Services
17157	Containers & Packaging
8522	Life Sciences Tools & Services
16787	Biotechnology
9068	Biotechnology
16965	Health Care Equipment & Supplies
17635	Life Sciences Tools & Services
10795	Life Sciences Tools & Services
17496	Life Sciences Tools & Services
9605	Professional Services
7072	Professional Services
9288	Diversified Consumer Services
17840	Professional Services
7073	Transportation Infrastructure
10135	Health Care Providers & Services
10961	Public Entities
10142	Health Care Providers & Services
8741	Commercial Services & Supplies
7069	Professional Services
9503	IT Services
16748	Software
16749	Diversified Consumer Services
17481	Trading Companies & Distributors
17636	Public Entities
9050	IT Services
9859	Hotels, Restaurants & Leisure
9906	Capital Markets
8317	Capital Markets
8317	Capital Markets
18308	Construction & Engineering
7075	Specialty Retail
17637	Construction & Engineering
7076	Professional Services
7074	Professional Services
18412	Construction & Engineering
9553	Household Durables
9563	Capital Markets
8785	Insurance
7077	Food Products
17788	Metals & Mining
7079	Software
7078	Multiline Retail
9315	Media
9315	Media
18132	Multiline Retail
10714	Diversified Financial Services
8829	Construction & Engineering
8829	Construction & Engineering
7080	Construction & Engineering
7080	Construction & Engineering
8912	Automobiles
9375	Consumer Finance
7081	Real Estate Management & Development
8914	Banks
7082	Pharmaceuticals
10231	Chemicals
9456	Machinery
8745	Personal Products
17159	Pharmaceuticals
9014	Aerospace & Defense
18195	Commercial Services & Supplies
7083	Food Products
9797	Commercial Services & Supplies
9109	Machinery
9110	Machinery
7084	Professional Services
10069	Specialty Retail
10912	Internet & Direct Marketing Retail
10726	Food & Staples Retailing
9504	Food Products
10486	Construction & Engineering
7085	Household Durables
10876	Construction & Engineering
16967	Household Durables
17880	Chemicals
7086	Professional Services
10011	Health Care Equipment & Supplies
7087	Internet Software & Services
17917	Construction & Engineering
7088	Diversified Consumer Services
17102	Beverages
17705	Construction & Engineering
8976	Construction & Engineering
9093	Household Durables
7089	Charity/Non-Profit
7089	Charity/Non-Profit
7090	Diversified Consumer Services
9145	Oil, Gas & Consumable Fuels
9653	Food Products
7091	Charity/Non-Profit
10077	Road & Rail
17351	Diversified Consumer Services
8524	Public Entities
10146	Health Care Providers & Services
10090	Specialty Retail
10901	Specialty Retail
7092	Household Durables
7093	Commercial Services & Supplies
9477	Transportation Infrastructure
7094	Health Care Technology
10100	Food & Staples Retailing
9465	Commercial Services & Supplies
9465	Commercial Services & Supplies
10013	Professional Services
17619	Trading Companies & Distributors
17619	Trading Companies & Distributors
17410	Media
17519	Construction & Engineering
7095	Charity/Non-Profit
17161	Communications Equipment
10599	Food Products
17163	Media
16968	Food Products
8525	Construction Materials
7096	Professional Services
17332	Construction & Engineering
7097	Trading Companies & Distributors
9541	Public Entities
10767	Capital Markets
8526	Capital Markets
8526	Capital Markets
17639	Household Durables
17385	Chemicals
7098	Textiles, Apparel & Luxury Goods
17411	Capital Markets
16762	Trading Companies & Distributors
9480	Metals & Mining
7099	Metals & Mining
7613	Building Products
9441	Commercial Services & Supplies
18495	Trading Companies & Distributors
16624	Construction & Engineering
7100	Machinery
7101	Food Products
9324	Diversified Consumer Services
7102	Internet & Direct Marketing Retail
7102	Internet & Direct Marketing Retail
10840	Media
8760	Professional Services
17706	Household Durables
18307	Building Products
16803	Transportation Infrastructure
18469	Multi-Utilities
7103	Pharmaceuticals
17521	Transportation Infrastructure
9419	Water Utilities
18384	Diversified Financial Services
9752	Energy Equipment & Services
9752	Energy Equipment & Services
17522	Professional Services
17522	Professional Services
10363	Pharmaceuticals
10051	Insurance
17803	Leisure Products
17889	Construction & Engineering
7104	Road & Rail
7105	Tobacco
7105	Tobacco
9829	Banks
9428	Media
9428	Media
10167	Banks
7106	Public Entities
17164	Professional Services
7107	Energy Equipment & Services
18482	Capital Markets
17352	Gas Utilities
7108	Charity/Non-Profit
7109	Professional Services
7110	Equity Real Estate Investment Trusts (REITs)
7110	Equity Real Estate Investment Trusts (REITs)
8767	Commercial Services & Supplies
7111	Charity/Non-Profit
9052	Charity/Non-Profit
17482	Metals & Mining
18013	Food Products
9023	Insurance
16969	Insurance
8716	Electric Utilities
8527	Beverages
8527	Beverages
7112	Charity/Non-Profit
9770	Beverages
17881	IT Services
18196	Commercial Services & Supplies
17875	Communications Equipment
18145	Metals & Mining
7113	Professional Services
10583	Insurance
18128	Real Estate Management & Development
17708	Health Care Providers & Services
18333	Charity/Non-Profit
10718	Textiles, Apparel & Luxury Goods
9969	Professional Services
7114	Professional Services
18151	Technology Hardware, Storage & Peripherals
9228	Technology Hardware, Storage & Peripherals
9228	Technology Hardware, Storage & Peripherals
16970	Chemicals
17990	Household Durables
7116	Professional Services
7115	Beverages
7115	Beverages
17412	Road & Rail
7117	Diversified Consumer Services
16813	Electrical Equipment
10925	Commercial Services & Supplies
7118	Construction & Engineering
7118	Construction & Engineering
17612	Commercial Services & Supplies
8528	Health Care Equipment & Supplies
9413	Paper & Forest Products
7119	IT Services
16641	Electrical Equipment
16843	Distributors
16971	Trading Companies & Distributors
9679	Diversified Telecommunication Services
16837	Capital Markets
7122	Pharmaceuticals
7120	Diversified Telecommunication Services
7120	Diversified Telecommunication Services
7121	IT Services
7123	Construction & Engineering
7124	Diversified Consumer Services
10697	Professional Services
9335	Automobiles
16917	Construction & Engineering
10445	Specialty Retail
17640	Household Durables
16962	Professional Services
18346	Capital Markets
7125	Technology Hardware, Storage & Peripherals
9385	Specialty Retail
7126	Personal Products
9159	Trading Companies & Distributors
18152	Household Durables
7127	Textiles, Apparel & Luxury Goods
7127	Textiles, Apparel & Luxury Goods
10275	Construction & Engineering
10275	Construction & Engineering
9766	Professional Services
9608	Building Products
9698	Professional Services
7128	Road & Rail
9483	Construction & Engineering
7129	Specialty Retail
10893	Trading Companies & Distributors
7130	Food Products
7131	Energy Equipment & Services
7132	Multiline Retail
17093	Commercial Services & Supplies
17093	Commercial Services & Supplies
16642	Oil, Gas & Consumable Fuels
7133	Software
17709	Construction & Engineering
7134	Construction & Engineering
7134	Construction & Engineering
7135	IT Services
16972	Charity/Non-Profit
10465	Software
18197	Auto Components
16802	Capital Markets
9084	Media
7136	Commercial Services & Supplies
9709	Media
10881	Construction & Engineering
8529	Road & Rail
9067	Hotels, Restaurants & Leisure
10298	IT Services
10298	IT Services
18501	Oil, Gas & Consumable Fuels
7137	Household Durables
7137	Household Durables
7138	Food Products
9756	Health Care Providers & Services
16688	Pharmaceuticals
17450	Metals & Mining
8530	Construction & Engineering
8530	Construction & Engineering
17333	Construction Materials
16776	Professional Services
10233	Commercial Services & Supplies
9811	Media
8710	Oil, Gas & Consumable Fuels
9336	Oil, Gas & Consumable Fuels
7139	Auto Components
8875	Consumer Finance
7140	Specialty Retail
18532	Health Care Providers & Services
9261	Media
7141	Food Products
10147	Health Care Providers & Services
7142	Trading Companies & Distributors
7143	Hotels, Restaurants & Leisure
7144	Textiles, Apparel & Luxury Goods
7145	Capital Markets
10398	Food Products
17804	Hotels, Restaurants & Leisure
9628	Capital Markets
10574	Insurance
10438	Insurance
10437	Insurance
8851	Banks
10647	Semiconductors & Semiconductor Equipment
9722	Charity/Non-Profit
9722	Charity/Non-Profit
10095	Real Estate Management & Development
7146	Life Sciences Tools & Services
7147	Charity/Non-Profit
10498	Construction & Engineering
9965	Health Care Providers & Services
10253	Household Durables
10346	Electronic Equipment, Instruments & Components
16814	Insurance
18521	Containers & Packaging
7148	Health Care Equipment & Supplies
9433	Health Care Equipment & Supplies
7149	Software
9102	Commercial Services & Supplies
9037	IT Services
7151	Real Estate Management & Development
7151	Real Estate Management & Development
10447	Thrifts & Mortgage Finance
18253	Commercial Services & Supplies
9869	Consumer Finance
9869	Consumer Finance
8808	Equity Real Estate Investment Trusts (REITs)
7150	Professional Services
7152	Professional Services
10361	Capital Markets
17311	IT Services
10476	Hotels, Restaurants & Leisure
7153	Chemicals
9471	Capital Markets
10727	Specialty Retail
7154	Diversified Consumer Services
7155	Diversified Consumer Services
10802	Health Care Providers & Services
8998	IT Services
16973	Charity/Non-Profit
7156	Health Care Providers & Services
17168	Health Care Providers & Services
7157	Construction & Engineering
7157	Construction & Engineering
10631	Professional Services
7158	Food Products
17523	Machinery
9307	Construction & Engineering
7159	Charity/Non-Profit
9817	Household Durables
18015	Building Products
10308	Hotels, Restaurants & Leisure
17308	Electrical Equipment
7160	Construction & Engineering
7161	Hotels, Restaurants & Leisure
17932	Chemicals
17283	Specialty Retail
7162	Professional Services
9890	Industrial Conglomerates
17391	Industrial Conglomerates
9999	Specialty Retail
7163	Real Estate Management & Development
7164	Electrical Equipment
16860	Road & Rail
10700	Machinery
7165	Electronic Equipment, Instruments & Components
7165	Electronic Equipment, Instruments & Components
7166	Distributors
16894	Real Estate Management & Development
9533	Public Entities
18198	Chemicals
7167	Hotels, Restaurants & Leisure
7167	Hotels, Restaurants & Leisure
7168	Life Sciences Tools & Services
17992	Real Estate Management & Development
7169	Charity/Non-Profit
16974	Commercial Services & Supplies
9005	Construction & Engineering
7171	Specialty Retail
7172	Construction & Engineering
9020	Household Durables
10501	Construction & Engineering
7173	Real Estate Management & Development
7173	Real Estate Management & Development
18269	Specialty Retail
16621	Media
10860	Commercial Services & Supplies
10367	IT Services
7174	Capital Markets
17919	Metals & Mining
7175	Software
7175	Software
7176	Software
18337	Capital Markets
17789	Capital Markets
17526	Food & Staples Retailing
16907	Electronic Equipment, Instruments & Components
16844	Capital Markets
16707	Pharmaceuticals
18199	Metals & Mining
7177	Media
7177	Media
7178	Construction Materials
17169	Capital Markets
10296	Hotels, Restaurants & Leisure
17616	Hotels, Restaurants & Leisure
17170	Food & Staples Retailing
17471	Specialty Retail
18510	Health Care Providers & Services
7179	Construction & Engineering
8803	Multi-Utilities
10883	Real Estate Management & Development
17171	Containers & Packaging
7180	Construction & Engineering
9562	Oil, Gas & Consumable Fuels
16806	Air Freight & Logistics
16804	Software
18228	Oil, Gas & Consumable Fuels
18345	IT Services
7181	IT Services
17820	Electrical Equipment
7183	Construction & Engineering
7184	Metals & Mining
7185	Construction & Engineering
8958	Charity/Non-Profit
7186	Specialty Retail
17710	Charity/Non-Profit
17413	Media
9008	Specialty Retail
9826	Media
10036	Airlines
16675	Hotels, Restaurants & Leisure
7187	Charity/Non-Profit
7187	Charity/Non-Profit
17991	Distributors
10333	Life Sciences Tools & Services
7188	Professional Services
7190	Capital Markets
8850	Professional Services
8531	Insurance
7191	Textiles, Apparel & Luxury Goods
7192	Beverages
7193	Diversified Consumer Services
10187	Banks
17389	Thrifts & Mortgage Finance
17394	Thrifts & Mortgage Finance
9973	Health Care Equipment & Supplies
10745	Diversified Financial Services
18200	Textiles, Apparel & Luxury Goods
7194	Insurance
7182	Hotels, Restaurants & Leisure
7182	Hotels, Restaurants & Leisure
9646	Construction & Engineering
7195	Food & Staples Retailing
17711	Real Estate Management & Development
17711	Real Estate Management & Development
10102	Public Entities
9609	Specialty Retail
7196	Media
18016	Chemicals
16861	Aerospace & Defense
17946	Chemicals
10188	Consumer Finance
10138	Health Care Providers & Services
7198	Insurance
17172	Health Care Providers & Services
8962	Real Estate Management & Development
18172	Oil, Gas & Consumable Fuels
8890	Oil, Gas & Consumable Fuels
17173	Capital Markets
10177	Banks
7199	Diversified Consumer Services
10839	Pharmaceuticals
7200	Charity/Non-Profit
9134	Media
18220	Banks
10605	Marine
9027	Marine
18096	Insurance
17414	Food & Staples Retailing
17969	Food Products
18201	Beverages
10031	Banks
9813	Health Care Providers & Services
17012	Charity/Non-Profit
9820	Charity/Non-Profit
10663	Specialty Retail
10777	Media
10226	Professional Services
7201	Health Care Providers & Services
16788	Diversified Consumer Services
10867	Insurance
9657	Electronic Equipment, Instruments & Components
9657	Electronic Equipment, Instruments & Components
9892	Pharmaceuticals
17415	Household Durables
9594	Commercial Services & Supplies
7202	Construction & Engineering
8756	Communications Equipment
18229	Banks
10642	Commercial Services & Supplies
10532	Media
18230	Professional Services
10546	Health Care Providers & Services
7203	Charity/Non-Profit
10638	Diversified Consumer Services
7205	Communications Equipment
7204	Commercial Services & Supplies
7204	Commercial Services & Supplies
10473	Banks
16708	Electronic Equipment, Instruments & Components
7206	Health Care Providers & Services
10938	Road & Rail
10307	Media
10125	Health Care Providers & Services
18167	Health Care Providers & Services
9528	Public Entities
17712	Trading Companies & Distributors
7208	Commercial Services & Supplies
7209	Air Freight & Logistics
17182	Real Estate Management & Development
8532	Software
10800	Textiles, Apparel & Luxury Goods
7210	Household Durables
10897	Household Durables
17088	Machinery
18263	Trading Companies & Distributors
10635	Specialty Retail
17324	Construction & Engineering
17174	Personal Products
9034	Media
9409	Real Estate Management & Development
10775	Hotels, Restaurants & Leisure
10834	Construction & Engineering
7211	Trading Companies & Distributors
17175	Construction & Engineering
7212	Professional Services
10728	Marine
10799	Pharmaceuticals
10131	Health Care Providers & Services
18153	Commercial Services & Supplies
17316	Commercial Services & Supplies
17176	Media
18082	Real Estate Management & Development
7213	Machinery
7213	Machinery
8917	Professional Services
9317	Hotels, Restaurants & Leisure
9457	Professional Services
9457	Professional Services
9073	Life Sciences Tools & Services
18264	Health Care Equipment & Supplies
7214	Personal Products
18284	Household Durables
9410	Commercial Services & Supplies
7215	Capital Markets
18530	Internet Software & Services
7216	Internet Software & Services
10612	Real Estate Management & Development
7217	Real Estate Management & Development
17416	Hotels, Restaurants & Leisure
10457	Construction & Engineering
7218	Real Estate Management & Development
7219	Professional Services
17153	Diversified Financial Services
7220	Capital Markets
18184	Capital Markets
16946	Media
9406	Commercial Services & Supplies
18481	Machinery
10927	Insurance
17417	Machinery
7902	Oil, Gas & Consumable Fuels
7902	Oil, Gas & Consumable Fuels
7221	Textiles, Apparel & Luxury Goods
7221	Textiles, Apparel & Luxury Goods
9763	Real Estate Management & Development
9833	Textiles, Apparel & Luxury Goods
7222	Textiles, Apparel & Luxury Goods
9622	Building Products
7223	Food & Staples Retailing
8788	Aerospace & Defense
9061	Beverages
10400	Beverages
9394	Beverages
9062	Beverages
17805	Oil, Gas & Consumable Fuels
7224	Media
10206	Diversified Telecommunication Services
17177	IT Services
7225	Aerospace & Defense
7225	Aerospace & Defense
7226	Construction & Engineering
7227	Construction & Engineering
7227	Construction & Engineering
9521	Public Entities
9281	Diversified Consumer Services
7228	Capital Markets
7229	Diversified Consumer Services
9197	Household Products
9670	Capital Markets
16647	Real Estate Management & Development
10528	Construction & Engineering
10267	Media
18548	Real Estate Management & Development
9092	Health Care Equipment & Supplies
17948	Machinery
18504	Charity/Non-Profit
7230	Banks
7230	Banks
10921	Professional Services
9881	Commercial Services & Supplies
16975	Charity/Non-Profit
17821	Diversified Financial Services
17167	Health Care Providers & Services
10543	Textiles, Apparel & Luxury Goods
9784	Food Products
17901	Professional Services
7231	Hotels, Restaurants & Leisure
7231	Hotels, Restaurants & Leisure
7232	Charity/Non-Profit
16976	Commercial Services & Supplies
7233	Professional Services
17888	Internet Software & Services
10003	Beverages
9164	IT Services
10319	Software
9649	Software
18102	Commercial Services & Supplies
7234	IT Services
9899	Building Products
7235	Life Sciences Tools & Services
10643	Media
10914	Media
10366	Construction & Engineering
7236	Distributors
7236	Distributors
7237	Real Estate Management & Development
9088	Capital Markets
8960	Oil, Gas & Consumable Fuels
7238	Commercial Services & Supplies
9311	Commercial Services & Supplies
7239	Health Care Equipment & Supplies
10829	Containers & Packaging
17870	Beverages
9891	Charity/Non-Profit
16620	Commercial Services & Supplies
7240	Media
7240	Media
8533	Professional Services
8770	Diversified Financial Services
16997	Auto Components
17353	Specialty Retail
9719	Distributors
17716	Professional Services
16862	Road & Rail
16862	Road & Rail
10527	Professional Services
9072	Health Care Equipment & Supplies
9207	IT Services
9207	IT Services
17231	Distributors
7241	Food & Staples Retailing
7241	Food & Staples Retailing
18071	Construction & Engineering
17882	Health Care Equipment & Supplies
7242	Food Products
17484	Textiles, Apparel & Luxury Goods
10190	Banks
9131	Banks
8784	Food Products
8784	Food Products
10935	Health Care Equipment & Supplies
17684	Food & Staples Retailing
18270	Chemicals
7244	Internet Software & Services
7245	Professional Services
7249	Commercial Services & Supplies
7249	Commercial Services & Supplies
7250	Real Estate Management & Development
16790	Distributors
17178	Distributors
7251	Household Durables
9737	Wireless Telecommunication Services
7252	Distributors
7253	Electronic Equipment, Instruments & Components
7253	Electronic Equipment, Instruments & Components
9434	Public Entities
17418	Charity/Non-Profit
7254	Gas Utilities
8947	Commercial Services & Supplies
17179	Commercial Services & Supplies
8534	Independent Power and Renewable Electricity Producers
17354	Marine
10941	Oil, Gas & Consumable Fuels
8694	Construction & Engineering
8694	Construction & Engineering
10401	Multiline Retail
10401	Multiline Retail
10709	Food & Staples Retailing
8725	Hotels, Restaurants & Leisure
9543	Beverages
9543	Beverages
10297	Specialty Retail
10590	Textiles, Apparel & Luxury Goods
16890	Personal Products
7257	Household Durables
7257	Household Durables
7256	Food Products
7255	Commercial Services & Supplies
7258	Health Care Providers & Services
16764	Real Estate Management & Development
7261	Health Care Providers & Services
8713	Construction & Engineering
10536	Insurance
17528	Banks
17528	Banks
18474	Diversified Consumer Services
8987	Containers & Packaging
10362	Professional Services
17822	Food Products
10502	Hotels, Restaurants & Leisure
7262	Oil, Gas & Consumable Fuels
17109	Commercial Services & Supplies
10953	Capital Markets
17180	Textiles, Apparel & Luxury Goods
16765	Marine
9044	Professional Services
9283	Diversified Consumer Services
7263	Food Products
9229	Technology Hardware, Storage & Peripherals
9147	Consumer Finance
17993	Electronic Equipment, Instruments & Components
16978	Charity/Non-Profit
17486	Distributors
18057	Banks
8535	Capital Markets
8535	Capital Markets
10435	Food Products
10792	Pharmaceuticals
7264	Electrical Equipment
7264	Electrical Equipment
8536	Household Durables
7265	Professional Services
17529	Specialty Retail
10283	Software
8911	Construction Materials
17970	Chemicals
16791	Capital Markets
16648	Internet Software & Services
7267	Commercial Services & Supplies
9160	Chemicals
17717	Trading Companies & Distributors
18564	Professional Services
10370	Real Estate Management & Development
7268	Machinery
8830	Household Durables
7269	Professional Services
7270	Professional Services
18534	Specialty Retail
7271	Capital Markets
9729	Machinery
7272	Oil, Gas & Consumable Fuels
10009	Containers & Packaging
9960	Health Care Providers & Services
9757	Construction & Engineering
10854	Capital Markets
8787	Hotels, Restaurants & Leisure
7273	Commercial Services & Supplies
7274	Biotechnology
9929	Hotels, Restaurants & Leisure
18460	Aerospace & Defense
7275	Air Freight & Logistics
10143	Health Care Providers & Services
16980	Construction & Engineering
8746	Charity/Non-Profit
7276	Professional Services
18556	Construction & Engineering
7277	Real Estate Management & Development
9304	Capital Markets
16649	Household Durables
8537	Banks
17530	Health Care Providers & Services
17531	Food & Staples Retailing
7280	Professional Services
7281	Professional Services
7281	Professional Services
10000	Air Freight & Logistics
7282	Real Estate Management & Development
17183	Trading Companies & Distributors
7283	Chemicals
7283	Chemicals
7284	Automobiles
7286	Food Products
7286	Food Products
9408	Diversified Telecommunication Services
18250	Capital Markets
10096	Diversified Financial Services
9911	Food & Staples Retailing
9715	Internet & Direct Marketing Retail
9715	Internet & Direct Marketing Retail
9103	Health Care Equipment & Supplies
8539	Oil, Gas & Consumable Fuels
9783	Professional Services
7287	Household Durables
17534	Media
7288	Professional Services
8931	Hotels, Restaurants & Leisure
8540	Food Products
8540	Food Products
10402	Food & Staples Retailing
17685	Banks
7289	IT Services
10123	Health Care Providers & Services
17719	Airlines
16922	Containers & Packaging
10633	Software
8541	Insurance
10627	Trading Companies & Distributors
7293	Specialty Retail
18032	Real Estate Management & Development
7294	Food Products
9629	Construction & Engineering
17617	Road & Rail
10538	Construction Materials
10819	Food & Staples Retailing
7295	Road & Rail
8793	Banks
7298	Industrial Conglomerates
7298	Industrial Conglomerates
7299	Health Care Providers & Services
17278	Specialty Retail
7296	Media
18566	Media
17871	Internet Software & Services
9734	Commercial Services & Supplies
9840	Metals & Mining
7305	Multiline Retail
9362	Professional Services
9669	Professional Services
10729	Pharmaceuticals
10729	Pharmaceuticals
10428	Construction Materials
7306	Real Estate Management & Development
9310	Construction & Engineering
7300	Commercial Services & Supplies
7302	Diversified Financial Services
7301	Commercial Services & Supplies
18409	Food Products
9511	Food & Staples Retailing
7307	Technology Hardware, Storage & Peripherals
7307	Technology Hardware, Storage & Peripherals
7308	Professional Services
7308	Professional Services
16807	Auto Components
7309	Charity/Non-Profit
7310	Commercial Services & Supplies
7303	Diversified Consumer Services
18285	Household Durables
7311	Energy Equipment & Services
7311	Energy Equipment & Services
9725	Machinery
18531	Media
18038	Household Durables
7312	Professional Services
17971	Health Care Equipment & Supplies
9376	Media
7304	Professional Services
10885	Professional Services
18558	Public Entities
10040	Health Care Providers & Services
8542	Equity Real Estate Investment Trusts (REITs)
7279	Internet Software & Services
9681	Commercial Services & Supplies
16981	Distributors
9116	Road & Rail
9004	Capital Markets
10880	Air Freight & Logistics
17994	Charity/Non-Profit
7313	Food Products
17009	Media
8543	Marine
10842	Household Durables
7314	Air Freight & Logistics
7315	Beverages
7315	Beverages
8706	Electrical Equipment
7316	Semiconductors & Semiconductor Equipment
10349	Health Care Equipment & Supplies
9827	Specialty Retail
7317	Professional Services
7318	Technology Hardware, Storage & Peripherals
18103	Media
9780	Diversified Consumer Services
17347	Capital Markets
8544	Charity/Non-Profit
10580	Trading Companies & Distributors
8944	Insurance
8944	Insurance
9640	Road & Rail
16983	Electrical Equipment
9104	Media
16984	Media
16985	Trading Companies & Distributors
8831	Trading Companies & Distributors
17419	Trading Companies & Distributors
18486	Hotels, Restaurants & Leisure
7319	Specialty Retail
7320	Professional Services
7320	Professional Services
7321	Food Products
16845	Communications Equipment
7322	Media
9074	Transportation Infrastructure
8703	Professional Services
17720	Specialty Retail
10926	Health Care Providers & Services
9726	Construction & Engineering
7323	Food Products
7324	Marine
7325	Consumer Finance
7326	Insurance
10613	Electronic Equipment, Instruments & Components
8545	Hotels, Restaurants & Leisure
7327	Specialty Retail
9659	Machinery
9778	Automobiles
9854	Aerospace & Defense
10951	Multi-Utilities
9179	Oil, Gas & Consumable Fuels
9182	Oil, Gas & Consumable Fuels
10952	Multi-Utilities
9181	Multi-Utilities
9183	Independent Power and Renewable Electricity Producers
9187	Independent Power and Renewable Electricity Producers
9184	Independent Power and Renewable Electricity Producers
9178	Oil, Gas & Consumable Fuels
7328	Electronic Equipment, Instruments & Components
8985	Capital Markets
7329	Construction & Engineering
10924	Professional Services
9664	Media
10025	Building Products
7330	Trading Companies & Distributors
7330	Trading Companies & Distributors
16766	Real Estate Management & Development
10244	Machinery
16633	Chemicals
16689	Chemicals
8547	Air Freight & Logistics
8546	Transportation Infrastructure
9666	Health Care Equipment & Supplies
16711	Oil, Gas & Consumable Fuels
7333	Commercial Services & Supplies
9771	Trading Companies & Distributors
7334	Independent Power and Renewable Electricity Producers
7335	Professional Services
10334	Textiles, Apparel & Luxury Goods
17532	Professional Services
7337	Construction & Engineering
7336	Containers & Packaging
7336	Containers & Packaging
10389	Diversified Financial Services
17085	Road & Rail
7338	Food Products
7338	Food Products
17320	Professional Services
9883	Specialty Retail
9163	Food Products
8804	Media
7339	Commercial Services & Supplies
10450	Electrical Equipment
10356	Health Care Equipment & Supplies
10189	Banks
7340	Professional Services
7332	Water Utilities
7341	Air Freight & Logistics
10851	Construction & Engineering
8538	Professional Services
8995	Household Durables
7343	Electronic Equipment, Instruments & Components
7344	Health Care Equipment & Supplies
7344	Health Care Equipment & Supplies
10126	Health Care Providers & Services
10153	Health Care Providers & Services
18104	Specialty Retail
8730	Health Care Providers & Services
9942	Health Care Providers & Services
16859	Charity/Non-Profit
7345	Public Entities
7346	Chemicals
10130	Health Care Providers & Services
9796	Real Estate Management & Development
8548	Airlines
8548	Airlines
8726	Hotels, Restaurants & Leisure
7347	Electrical Equipment
7348	Software
8549	Media
9746	Machinery
10710	Insurance
10309	Diversified Consumer Services
10828	Pharmaceuticals
10828	Pharmaceuticals
17950	Chemicals
7349	Media
7350	Media
7351	Independent Power and Renewable Electricity Producers
10535	Insurance
10455	Textiles, Apparel & Luxury Goods
17185	Professional Services
10582	Machinery
9087	Multi-Utilities
8550	Food & Staples Retailing
10910	Multi-Utilities
10965	Media
7352	Diversified Consumer Services
17791	Trading Companies & Distributors
7353	Independent Power and Renewable Electricity Producers
7354	Diversified Consumer Services
7354	Diversified Consumer Services
7355	Internet Software & Services
7356	Trading Companies & Distributors
7357	Beverages
7358	Charity/Non-Profit
10660	Commercial Services & Supplies
17825	Hotels, Restaurants & Leisure
17535	Machinery
7359	Wireless Telecommunication Services
17186	Professional Services
9785	Household Durables
7360	Household Durables
7361	Building Products
7361	Building Products
17995	Household Products
8551	Media
8551	Media
10224	Food & Staples Retailing
8552	Hotels, Restaurants & Leisure
10808	Health Care Providers & Services
10808	Health Care Providers & Services
10808	Health Care Providers & Services
10858	Construction & Engineering
17355	Health Care Equipment & Supplies
17187	Household Durables
18509	Commercial Services & Supplies
7362	Electric Utilities
7362	Electric Utilities
8775	Electric Utilities
10320	Electronic Equipment, Instruments & Components
7363	Electronic Equipment, Instruments & Components
7364	Aerospace & Defense
17421	Household Durables
9395	Electrical Equipment
10730	Chemicals
8936	Pharmaceuticals
8936	Pharmaceuticals
8553	Hotels, Restaurants & Leisure
8553	Hotels, Restaurants & Leisure
7365	Personal Products
8886	Metals & Mining
18254	Food Products
9740	Trading Companies & Distributors
7366	Construction & Engineering
7367	Software
7367	Software
7368	Technology Hardware, Storage & Peripherals
7369	Construction & Engineering
9017	Media
17951	Chemicals
9343	Health Care Providers & Services
10567	Independent Power and Renewable Electricity Producers
9365	Electrical Equipment
7370	Real Estate Management & Development
7371	Charity/Non-Profit
10680	Food Products
16835	Food Products
7372	Oil, Gas & Consumable Fuels
9308	Professional Services
8554	Commercial Services & Supplies
10018	Capital Markets
10923	Containers & Packaging
7373	Trading Companies & Distributors
7374	Professional Services
7375	IT Services
17771	Electronic Equipment, Instruments & Components
10592	Construction & Engineering
7376	Household Products
17188	Commercial Services & Supplies
10441	Construction & Engineering
7377	Electric Utilities
7377	Electric Utilities
9825	Media
10260	Hotels, Restaurants & Leisure
8555	Charity/Non-Profit
17189	Media
18202	Food Products
10237	Oil, Gas & Consumable Fuels
7378	Distributors
9025	Oil, Gas & Consumable Fuels
7379	Diversified Financial Services
10192	Diversified Financial Services
16767	Food Products
7380	Construction & Engineering
7005	IT Services
9555	Diversified Consumer Services
7381	Media
7382	Capital Markets
7382	Capital Markets
7383	Commercial Services & Supplies
9238	Electrical Equipment
9864	Electric Utilities
7342	Trading Companies & Distributors
8766	Industrial Conglomerates
18519	Software
7384	Technology Hardware, Storage & Peripherals
7384	Technology Hardware, Storage & Peripherals
7385	Electronic Equipment, Instruments & Components
7385	Electronic Equipment, Instruments & Components
9379	Building Products
9995	Capital Markets
9204	IT Services
18203	Professional Services
7386	Insurance
17996	Distributors
7387	Capital Markets
16987	Technology Hardware, Storage & Peripherals
7388	Communications Equipment
7388	Communications Equipment
8852	Construction & Engineering
8852	Construction & Engineering
10824	Professional Services
8556	Professional Services
8556	Professional Services
8557	Consumer Finance
17572	Banks
9323	Specialty Retail
9855	Media
7389	Electric Utilities
7391	Public Entities
7391	Public Entities
7392	Software
7393	Oil, Gas & Consumable Fuels
8558	Chemicals
9761	Charity/Non-Profit
7394	Public Entities
9887	Electrical Equipment
18453	Oil, Gas & Consumable Fuels
18458	Oil, Gas & Consumable Fuels
17425	Oil, Gas & Consumable Fuels
8999	Internet Software & Services
9199	Personal Products
8559	Charity/Non-Profit
8935	Insurance
9554	Real Estate Management & Development
18320	Building Products
10685	Internet & Direct Marketing Retail
16988	Insurance
7395	Internet Software & Services
10943	Distributors
17492	Building Products
9586	Capital Markets
7396	Commercial Services & Supplies
18515	Electrical Equipment
17107	Life Sciences Tools & Services
16989	Food Products
7397	Oil, Gas & Consumable Fuels
7397	Oil, Gas & Consumable Fuels
8971	Media
8560	Media
8789	Containers & Packaging
9141	Road & Rail
10537	IT Services
7398	Food Products
9888	Banks
17190	Road & Rail
17191	Chemicals
10488	Household Durables
7399	Professional Services
7399	Professional Services
8977	Trading Companies & Distributors
7400	Media
16792	Consumer Finance
16924	Oil, Gas & Consumable Fuels
7401	Distributors
8984	Commercial Services & Supplies
7402	Health Care Providers & Services
18347	Chemicals
16990	Machinery
8561	Professional Services
18073	Metals & Mining
17423	Food Products
9364	Communications Equipment
10861	Construction & Engineering
17537	Diversified Financial Services
17646	Health Care Providers & Services
7403	Real Estate Management & Development
10785	Health Care Providers & Services
7404	Air Freight & Logistics
7405	Electronic Equipment, Instruments & Components
7405	Electronic Equipment, Instruments & Components
18488	Insurance
8718	Electronic Equipment, Instruments & Components
10020	Professional Services
18173	Internet & Direct Marketing Retail
16846	Air Freight & Logistics
9203	Professional Services
17424	Professional Services
7406	Professional Services
7406	Professional Services
9660	Professional Services
18574	Household Durables
17194	Hotels, Restaurants & Leisure
17195	IT Services
7407	Banks
7407	Banks
9880	Internet & Direct Marketing Retail
16991	Metals & Mining
17327	Media
18470	Energy Equipment & Services
10060	Professional Services
18455	Chemicals
18456	Commercial Services & Supplies
18457	Oil, Gas & Consumable Fuels
17817	Oil, Gas & Consumable Fuels
18286	Distributors
9798	Food Products
8818	Capital Markets
8818	Capital Markets
9046	Commercial Services & Supplies
7408	Distributors
8562	Diversified Consumer Services
10838	Real Estate Management & Development
17196	Independent Power and Renewable Electricity Producers
9716	Diversified Consumer Services
18154	Insurance
10207	Charity/Non-Profit
10369	Food & Staples Retailing
16898	Machinery
7410	Professional Services
7411	Chemicals
17426	Commercial Services & Supplies
17538	Internet Software & Services
10655	Specialty Retail
16779	Professional Services
7412	Specialty Retail
18562	Professional Services
10716	Food & Staples Retailing
10182	Banks
16993	Consumer Finance
16706	Commercial Services & Supplies
17608	Commercial Services & Supplies
17647	Consumer Finance
10731	IT Services
17924	Auto Components
17924	Auto Components
7414	Air Freight & Logistics
10920	Air Freight & Logistics
10920	Air Freight & Logistics
17973	Electronic Equipment, Instruments & Components
17939	Commercial Services & Supplies
10886	Household Durables
17539	Leisure Products
18058	Commercial Services & Supplies
10611	Machinery
9916	Trading Companies & Distributors
9916	Trading Companies & Distributors
17688	Capital Markets
9914	Specialty Retail
9914	Specialty Retail
7246	Food Products
9875	Metals & Mining
7415	Machinery
16994	Pharmaceuticals
16995	Media
7416	Trading Companies & Distributors
8774	Specialty Retail
17723	Automobiles
7413	Specialty Retail
7417	Communications Equipment
17199	Insurance
10764	IT Services
7418	Software
9464	Professional Services
7419	Diversified Consumer Services
17335	Commercial Services & Supplies
7420	Capital Markets
7420	Capital Markets
10841	Internet Software & Services
8981	Professional Services
9224	Media
16663	Software
10653	Software
8720	Internet & Direct Marketing Retail
8720	Internet & Direct Marketing Retail
17844	Capital Markets
17648	Beverages
7421	Food Products
10474	Trading Companies & Distributors
9596	Food Products
7422	Professional Services
17911	Diversified Consumer Services
7423	Diversified Financial Services
8563	Diversified Consumer Services
17108	Insurance
7424	Real Estate Management & Development
7424	Real Estate Management & Development
18094	IT Services
7425	IT Services
7426	Road & Rail
7426	Road & Rail
16996	Food Products
16996	Food Products
9981	Professional Services
8564	Consumer Finance
18105	Diversified Financial Services
17428	Health Care Providers & Services
17429	Banks
18019	Road & Rail
18040	Specialty Retail
16713	Capital Markets
9922	Textiles, Apparel & Luxury Goods
10122	Food & Staples Retailing
17560	Professional Services
17997	Machinery
17997	Machinery
8565	Distributors
8566	Machinery
7427	Chemicals
9016	IT Services
7428	Hotels, Restaurants & Leisure
7430	Professional Services
7429	Electronic Equipment, Instruments & Components
7431	Electronic Equipment, Instruments & Components
16998	Chemicals
9782	Oil, Gas & Consumable Fuels
9782	Oil, Gas & Consumable Fuels
16816	Building Products
8872	Food Products
16999	Electrical Equipment
9347	Machinery
9347	Machinery
10620	Machinery
10852	Construction & Engineering
7432	Airlines
7432	Airlines
10798	Health Care Providers & Services
18257	Chemicals
9680	Construction & Engineering
17200	Insurance
10273	Technology Hardware, Storage & Peripherals
18480	Professional Services
10414	Media
17724	Professional Services
7433	Specialty Retail
7433	Specialty Retail
7434	Media
16926	Specialty Retail
7435	Automobiles
7436	Specialty Retail
10690	Capital Markets
9982	Professional Services
18204	Insurance
9519	Public Entities
7437	Public Entities
7437	Public Entities
18074	Food Products
7331	Trading Companies & Distributors
8979	Paper & Forest Products
9762	Specialty Retail
9312	Hotels, Restaurants & Leisure
7438	Construction & Engineering
10888	Professional Services
16691	Construction Materials
9621	Diversified Financial Services
17896	IT Services
7439	Charity/Non-Profit
18560	Electronic Equipment, Instruments & Components
16899	Commercial Services & Supplies
7440	Professional Services
18124	Media
16812	Capital Markets
9349	Health Care Providers & Services
9416	Road & Rail
17974	Real Estate Management & Development
17201	Food Products
7441	Construction Materials
10711	Chemicals
17000	Commercial Services & Supplies
10578	Professional Services
17202	Capital Markets
16834	Professional Services
7442	Construction & Engineering
8989	Beverages
18343	Hotels, Restaurants & Leisure
18311	Industrial Conglomerates
7443	Textiles, Apparel & Luxury Goods
7444	Hotels, Restaurants & Leisure
18300	Construction & Engineering
7445	Media
9501	Metals & Mining
7446	Professional Services
17998	Food & Staples Retailing
9148	Road & Rail
9148	Road & Rail
7447	Air Freight & Logistics
10905	Media
17203	Specialty Retail
7448	Food & Staples Retailing
7448	Food & Staples Retailing
7449	Pharmaceuticals
17001	Health Care Providers & Services
10331	Food & Staples Retailing
7450	Professional Services
9422	Food Products
9765	Metals & Mining
17540	Media
9956	Health Care Providers & Services
18550	Commercial Services & Supplies
7451	Food Products
10007	Commercial Services & Supplies
10337	Health Care Providers & Services
9300	Media
8926	Professional Services
9707	Chemicals
9707	Chemicals
7452	Oil, Gas & Consumable Fuels
7453	Technology Hardware, Storage & Peripherals
9613	Life Sciences Tools & Services
9613	Life Sciences Tools & Services
7454	Health Care Equipment & Supplies
10252	Electrical Equipment
7455	IT Services
10616	Gas Utilities
18484	Media
16781	IT Services
18059	Specialty Retail
18545	Commercial Services & Supplies
10411	Media
7456	Household Durables
9631	Food Products
18309	Specialty Retail
7457	Electrical Equipment
9244	Food & Staples Retailing
8925	Commercial Services & Supplies
10868	Household Durables
7459	Construction & Engineering
7459	Construction & Engineering
7460	Professional Services
17165	Capital Markets
17357	Airlines
7461	Specialty Retail
7462	Leisure Products
7463	Software
9132	Diversified Telecommunication Services
17356	Capital Markets
16666	Media
17650	Distributors
17005	Food Products
9755	Trading Companies & Distributors
9356	Specialty Retail
8567	Professional Services
7464	Professional Services
7464	Professional Services
8937	Energy Equipment & Services
8811	Transportation Infrastructure
7465	Specialty Retail
7466	Building Products
16768	Commercial Services & Supplies
7467	Professional Services
7468	Professional Services
9527	Professional Services
10676	Machinery
7469	Charity/Non-Profit
17800	Machinery
7470	Professional Services
7470	Professional Services
7471	Transportation Infrastructure
10853	Construction & Engineering
10542	Oil, Gas & Consumable Fuels
10702	Air Freight & Logistics
10329	Textiles, Apparel & Luxury Goods
7472	Software
17738	Multi-Utilities
10696	Specialty Retail
8738	Road & Rail
7473	Health Care Providers & Services
7473	Health Care Providers & Services
10844	Health Care Equipment & Supplies
7474	Machinery
17206	Internet & Direct Marketing Retail
10684	Household Durables
8568	Household Durables
9042	Software
17007	Metals & Mining
9779	Metals & Mining
8832	Software
9436	Building Products
18461	Commercial Services & Supplies
8569	Charity/Non-Profit
8569	Charity/Non-Profit
7475	Food Products
7475	Food Products
9449	Automobiles
9845	Capital Markets
9001	Capital Markets
7476	Charity/Non-Profit
7476	Charity/Non-Profit
16750	IT Services
7477	Industrial Conglomerates
10088	Biotechnology
8776	Commercial Services & Supplies
18294	Construction & Engineering
17952	Chemicals
9424	Real Estate Management & Development
9934	Hotels, Restaurants & Leisure
17207	Distributors
7479	Health Care Providers & Services
10843	Media
17431	Media
8820	Construction & Engineering
9105	Diversified Financial Services
7480	Construction & Engineering
17208	Electronic Equipment, Instruments & Components
17323	Diversified Telecommunication Services
10670	Specialty Retail
7481	Professional Services
17725	Construction & Engineering
10668	Textiles, Apparel & Luxury Goods
8966	Charity/Non-Profit
17008	Media
17008	Media
18514	Internet Software & Services
17209	Chemicals
10315	Textiles, Apparel & Luxury Goods
16797	Trading Companies & Distributors
7482	Auto Components
18205	Real Estate Management & Development
17541	Food & Staples Retailing
17432	Transportation Infrastructure
9291	Diversified Consumer Services
8570	Pharmaceuticals
8570	Pharmaceuticals
7483	Food & Staples Retailing
16817	Electrical Equipment
8866	Metals & Mining
8571	Commercial Services & Supplies
10831	Health Care Providers & Services
7484	Textiles, Apparel & Luxury Goods
7485	Hotels, Restaurants & Leisure
10787	Food & Staples Retailing
17433	Insurance
18563	Diversified Financial Services
17583	Hotels, Restaurants & Leisure
7486	Diversified Consumer Services
9924	Software
18175	IT Services
17211	Diversified Telecommunication Services
7487	Textiles, Apparel & Luxury Goods
7488	Technology Hardware, Storage & Peripherals
7488	Technology Hardware, Storage & Peripherals
17910	Building Products
7489	Construction & Engineering
7489	Construction & Engineering
18206	Textiles, Apparel & Luxury Goods
7490	Road & Rail
7490	Road & Rail
9368	Internet Software & Services
17953	Personal Products
17434	Marine
16848	Hotels, Restaurants & Leisure
16715	Charity/Non-Profit
17010	Capital Markets
7492	Hotels, Restaurants & Leisure
9269	Diversified Consumer Services
9269	Diversified Consumer Services
17542	Road & Rail
9868	Electronic Equipment, Instruments & Components
10778	Independent Power and Renewable Electricity Producers
17502	Real Estate Management & Development
17488	Auto Components
18353	Machinery
17011	Machinery
7494	Hotels, Restaurants & Leisure
18372	Auto Components
10683	Building Products
9216	Hotels, Restaurants & Leisure
7491	Commercial Services & Supplies
7495	Paper & Forest Products
17205	Hotels, Restaurants & Leisure
7496	Professional Services
7496	Professional Services
7497	Food & Staples Retailing
10862	Construction & Engineering
18350	Chemicals
16769	Building Products
17543	Textiles, Apparel & Luxury Goods
10733	Trading Companies & Distributors
10733	Trading Companies & Distributors
17726	Professional Services
7498	Machinery
17212	Household Durables
8572	Real Estate Management & Development
17014	Trading Companies & Distributors
7500	Food Products
7499	Household Durables
17213	Commercial Services & Supplies
8573	Professional Services
10407	Professional Services
7501	Professional Services
16704	Containers & Packaging
16716	Containers & Packaging
10371	Construction & Engineering
10902	Commercial Services & Supplies
9544	Public Entities
18129	Health Care Providers & Services
7504	Health Care Providers & Services
7502	Charity/Non-Profit
7503	Equity Real Estate Investment Trusts (REITs)
7503	Equity Real Estate Investment Trusts (REITs)
17748	Hotels, Restaurants & Leisure
17727	Hotels, Restaurants & Leisure
9941	Health Care Providers & Services
7506	Food & Staples Retailing
9873	Food Products
7507	Hotels, Restaurants & Leisure
18312	Trading Companies & Distributors
10305	Charity/Non-Profit
10396	Food Products
9559	Hotels, Restaurants & Leisure
9559	Hotels, Restaurants & Leisure
16714	Road & Rail
17214	Containers & Packaging
7508	Diversified Consumer Services
10310	Food & Staples Retailing
10405	Capital Markets
9696	Construction & Engineering
7509	Commercial Services & Supplies
8870	Road & Rail
7510	Internet & Direct Marketing Retail
7510	Internet & Direct Marketing Retail
10602	Charity/Non-Profit
17215	Food Products
16895	Commercial Services & Supplies
18232	Diversified Consumer Services
16941	Food Products
7511	Commercial Services & Supplies
7458	Commercial Services & Supplies
17307	Electrical Equipment
17792	Automobiles
16623	Household Durables
8574	Charity/Non-Profit
17767	Commercial Services & Supplies
7512	Household Durables
18183	Capital Markets
8575	Energy Equipment & Services
9590	Energy Equipment & Services
10348	Road & Rail
17013	Chemicals
9950	Health Care Providers & Services
18498	Hotels, Restaurants & Leisure
10351	Health Care Providers & Services
7514	Hotels, Restaurants & Leisure
10364	Media
7515	Textiles, Apparel & Luxury Goods
9597	Metals & Mining
7516	Charity/Non-Profit
18182	Trading Companies & Distributors
10524	Electronic Equipment, Instruments & Components
9513	Food Products
8695	Hotels, Restaurants & Leisure
8845	Beverages
7517	Specialty Retail
7517	Specialty Retail
16652	Machinery
17544	Specialty Retail
18561	Media
7518	Distributors
7519	Beverages
7520	Electronic Equipment, Instruments & Components
7520	Electronic Equipment, Instruments & Components
8945	Real Estate Management & Development
7521	Household Durables
9947	Health Care Providers & Services
16721	Health Care Providers & Services
8919	Hotels, Restaurants & Leisure
9500	Hotels, Restaurants & Leisure
7522	Charity/Non-Profit
10673	Building Products
7523	Construction Materials
7524	Construction Materials
7524	Construction Materials
10734	Equity Real Estate Investment Trusts (REITs)
7525	Trading Companies & Distributors
7526	Hotels, Restaurants & Leisure
17015	Hotels, Restaurants & Leisure
10735	Capital Markets
10687	Hotels, Restaurants & Leisure
7527	Building Products
7528	IT Services
7529	Capital Markets
7529	Capital Markets
7530	Oil, Gas & Consumable Fuels
8576	Specialty Retail
10220	Distributors
10221	Distributors
7531	Household Durables
7532	Diversified Consumer Services
9814	Professional Services
9692	Food Products
17489	Construction & Engineering
10494	Commercial Services & Supplies
18090	Trading Companies & Distributors
9482	Multiline Retail
17651	Real Estate Management & Development
10894	Construction & Engineering
16625	Metals & Mining
8577	Electrical Equipment
9351	Specialty Retail
9175	Specialty Retail
18034	Construction & Engineering
7533	Leisure Products
18044	Construction & Engineering
10736	Insurance
17920	Construction & Engineering
9328	Household Durables
10539	Electrical Equipment
10345	Diversified Financial Services
17887	Trading Companies & Distributors
10895	Real Estate Management & Development
16628	Diversified Financial Services
7534	Media
17605	Metals & Mining
7535	Professional Services
9667	Chemicals
10900	Construction & Engineering
7536	Health Care Providers & Services
9992	Metals & Mining
16927	Road & Rail
9138	Distributors
10340	Professional Services
7537	Professional Services
18500	Health Care Providers & Services
7538	Health Care Providers & Services
8772	Health Care Providers & Services
9968	Health Care Providers & Services
7539	Health Care Providers & Services
17807	Insurance
18356	Health Care Providers & Services
8578	Food & Staples Retailing
7540	Health Care Providers & Services
8579	Diversified Consumer Services
8959	Transportation Infrastructure
17218	Specialty Retail
17546	Trading Companies & Distributors
7541	Beverages
7542	Real Estate Management & Development
7542	Real Estate Management & Development
10417	Energy Equipment & Services
18303	Machinery
16653	Air Freight & Logistics
18506	Health Care Providers & Services
10931	Diversified Telecommunication Services
17435	Commercial Services & Supplies
17547	Specialty Retail
7543	Household Durables
7543	Household Durables
7544	Health Care Providers & Services
9900	Personal Products
7545	Professional Services
7545	Professional Services
7546	Construction & Engineering
7546	Construction & Engineering
9256	Diversified Consumer Services
7547	Commercial Services & Supplies
7548	Commercial Services & Supplies
10314	Diversified Financial Services
7549	Professional Services
10404	Food Products
9345	Diversified Consumer Services
7550	Trading Companies & Distributors
8796	Technology Hardware, Storage & Peripherals
10594	Auto Components
18511	Road & Rail
7551	Distributors
18565	Food Products
7552	Charity/Non-Profit
8877	Capital Markets
8877	Capital Markets
8727	Specialty Retail
9712	Media
9451	Media
16665	Building Products
7553	Capital Markets
10561	Diversified Financial Services
9851	Capital Markets
16794	Distributors
9570	Beverages
10485	Charity/Non-Profit
9955	Pharmaceuticals
7555	Household Durables
7554	Professional Services
7556	Commercial Services & Supplies
8580	Metals & Mining
7557	Beverages
7558	Machinery
7559	Hotels, Restaurants & Leisure
7560	Trading Companies & Distributors
8769	Public Entities
7561	Charity/Non-Profit
7562	Diversified Financial Services
7562	Diversified Financial Services
7563	Trading Companies & Distributors
7564	Professional Services
7565	Industrial Conglomerates
7566	Electrical Equipment
7567	Electronic Equipment, Instruments & Components
7568	Machinery
7513	Food & Staples Retailing
10219	Food & Staples Retailing
10540	Real Estate Management & Development
8888	Specialty Retail
16940	Specialty Retail
18449	Specialty Retail
7569	Professional Services
7569	Professional Services
10212	Specialty Retail
7570	Commercial Services & Supplies
10837	Construction & Engineering
9298	Professional Services
17217	Media
7571	Professional Services
9580	Food & Staples Retailing
7572	Hotels, Restaurants & Leisure
9496	Hotels, Restaurants & Leisure
10225	Food & Staples Retailing
9560	Professional Services
18464	Paper & Forest Products
17436	Hotels, Restaurants & Leisure
17017	Specialty Retail
7574	Specialty Retail
7575	Health Care Providers & Services
7573	Charity/Non-Profit
9908	Real Estate Management & Development
7576	Public Entities
7578	Commercial Services & Supplies
7578	Commercial Services & Supplies
7577	Charity/Non-Profit
7579	Specialty Retail
9821	Internet Software & Services
10360	Food & Staples Retailing
7580	Electric Utilities
7580	Electric Utilities
10071	Professional Services
10068	Food Products
9957	Health Care Providers & Services
7581	Multiline Retail
9632	Charity/Non-Profit
9786	Real Estate Management & Development
7582	Professional Services
7582	Professional Services
7583	Trading Companies & Distributors
7584	Health Care Equipment & Supplies
17751	Construction & Engineering
17490	Health Care Equipment & Supplies
7585	Technology Hardware, Storage & Peripherals
7586	Transportation Infrastructure
7586	Transportation Infrastructure
7587	Banks
10442	Trading Companies & Distributors
18120	Machinery
7588	Specialty Retail
10186	Banks
18434	Commercial Services & Supplies
7589	Professional Services
7590	Commercial Services & Supplies
9432	Specialty Retail
10047	Professional Services
8856	Textiles, Apparel & Luxury Goods
7591	Containers & Packaging
7592	Health Care Providers & Services
7592	Health Care Providers & Services
10303	Charity/Non-Profit
10107	Health Care Providers & Services
7593	Food Products
17360	Textiles, Apparel & Luxury Goods
10737	Energy Equipment & Services
10737	Energy Equipment & Services
7594	Aerospace & Defense
16900	Professional Services
9582	Chemicals
7595	Professional Services
7595	Professional Services
8581	Media
8582	Media
18114	Transportation Infrastructure
18288	Construction & Engineering
9630	Trading Companies & Distributors
16896	Commercial Services & Supplies
8729	Machinery
9412	Real Estate Management & Development
17549	Real Estate Management & Development
17491	Machinery
18041	Machinery
17550	Capital Markets
7596	Professional Services
10608	Specialty Retail
7597	Professional Services
17999	Distributors
7598	Insurance
10016	Specialty Retail
17551	Air Freight & Logistics
7600	Hotels, Restaurants & Leisure
7601	Professional Services
10738	Construction Materials
7602	Commercial Services & Supplies
9919	Food Products
7603	Water Utilities
10330	Professional Services
10026	Professional Services
9834	Textiles, Apparel & Luxury Goods
9107	Textiles, Apparel & Luxury Goods
7605	Banks
10657	Hotels, Restaurants & Leisure
17390	Life Sciences Tools & Services
7606	Commercial Services & Supplies
7607	Household Durables
7608	Household Durables
9399	Oil, Gas & Consumable Fuels
10497	Health Care Equipment & Supplies
10497	Health Care Equipment & Supplies
17438	Health Care Equipment & Supplies
7609	Health Care Providers & Services
10203	Professional Services
10203	Professional Services
8864	Construction & Engineering
10282	Commercial Services & Supplies
18207	IT Services
7610	Trading Companies & Distributors
17019	Diversified Financial Services
10062	Capital Markets
10029	Household Durables
7611	Capital Markets
7611	Capital Markets
17732	Hotels, Restaurants & Leisure
17732	Hotels, Restaurants & Leisure
17041	Distributors
8869	Professional Services
7612	Banks
17020	Specialty Retail
10836	Capital Markets
10873	Construction & Engineering
7614	Building Products
9322	Machinery
7615	Media
7616	Semiconductors & Semiconductor Equipment
7617	Hotels, Restaurants & Leisure
7618	Professional Services
7618	Professional Services
10739	Machinery
17552	Diversified Consumer Services
8705	Professional Services
7619	Professional Services
7619	Professional Services
7620	Tobacco
7620	Tobacco
7620	Tobacco
18355	Chemicals
9958	Health Care Providers & Services
9958	Health Care Providers & Services
10577	Hotels, Restaurants & Leisure
10623	Software
18078	Construction & Engineering
7621	Distributors
18000	Transportation Infrastructure
8583	Distributors
8902	Media
7622	Media
7623	Real Estate Management & Development
7623	Real Estate Management & Development
10042	Commercial Services & Supplies
16774	Health Care Providers & Services
9675	Hotels, Restaurants & Leisure
9358	Specialty Retail
8887	Pharmaceuticals
17437	Banks
10377	Machinery
7624	Professional Services
7625	Professional Services
9231	Semiconductors & Semiconductor Equipment
7626	Communications Equipment
7627	Independent Power and Renewable Electricity Producers
8714	Energy Equipment & Services
7628	Media
18573	IT Services
7629	IT Services
9032	Electronic Equipment, Instruments & Components
9021	Capital Markets
9039	Professional Services
7630	Food Products
7631	Distributors
9437	Health Care Providers & Services
9878	Real Estate Management & Development
8923	Diversified Telecommunication Services
8799	Beverages
8891	Chemicals
10788	Public Entities
10045	Commercial Services & Supplies
7632	Oil, Gas & Consumable Fuels
9775	Electronic Equipment, Instruments & Components
7599	Professional Services
10614	Professional Services
7854	Multiline Retail
7633	Charity/Non-Profit
7633	Charity/Non-Profit
8715	Diversified Consumer Services
9290	Diversified Consumer Services
7634	Building Products
8990	Insurance
10249	Software
9338	Capital Markets
7635	Health Care Providers & Services
17683	Health Care Providers & Services
8704	Health Care Providers & Services
7636	Semiconductors & Semiconductor Equipment
18487	Independent Power and Renewable Electricity Producers
10617	Electronic Equipment, Instruments & Components
16751	Health Care Providers & Services
7638	IT Services
7639	Oil, Gas & Consumable Fuels
7640	Hotels, Restaurants & Leisure
7640	Hotels, Restaurants & Leisure
7641	Building Products
7642	Electric Utilities
7604	Capital Markets
10637	IT Services
8739	Airlines
8696	Beverages
9301	IT Services
7643	Chemicals
8967	Hotels, Restaurants & Leisure
7644	Paper & Forest Products
10823	Charity/Non-Profit
9792	Construction & Engineering
18348	Chemicals
7645	Paper & Forest Products
9862	Consumer Finance
18003	Construction Materials
9993	Independent Power and Renewable Electricity Producers
8584	Charity/Non-Profit
18106	Health Care Providers & Services
17483	Professional Services
10477	Commercial Services & Supplies
8585	Professional Services
8585	Professional Services
7637	Oil, Gas & Consumable Fuels
7637	Oil, Gas & Consumable Fuels
10806	Pharmaceuticals
17219	IT Services
8586	Equity Real Estate Investment Trusts (REITs)
17902	Beverages
7646	Banks
10820	Professional Services
9898	Real Estate Management & Development
10818	Pharmaceuticals
8862	Media
7647	Semiconductors & Semiconductor Equipment
8908	Real Estate Management & Development
17784	Software
8854	Software
7648	Professional Services
7649	Construction & Engineering
10790	Machinery
18538	Public Entities
10452	Commercial Services & Supplies
10216	Specialty Retail
10193	Hotels, Restaurants & Leisure
7650	Insurance
9299	Media
17118	Hotels, Restaurants & Leisure
8780	Media
17925	Machinery
10934	Capital Markets
18473	Commercial Services & Supplies
10740	Commercial Services & Supplies
18130	Electronic Equipment, Instruments & Components
8913	Media
8913	Media
17022	Construction & Engineering
17023	Textiles, Apparel & Luxury Goods
9458	Construction & Engineering
17894	Internet & Direct Marketing Retail
8587	Automobiles
8587	Automobiles
10304	Professional Services
10344	Chemicals
7654	Building Products
7655	Paper & Forest Products
17652	Textiles, Apparel & Luxury Goods
9418	Food Products
9372	Oil, Gas & Consumable Fuels
8819	Specialty Retail
7656	Professional Services
10509	Textiles, Apparel & Luxury Goods
17604	Paper & Forest Products
10705	Trading Companies & Distributors
7657	Food Products
9174	Hotels, Restaurants & Leisure
9327	Capital Markets
10472	Pharmaceuticals
18527	Airlines
7658	Household Durables
10741	Insurance
17845	Machinery
17025	Trading Companies & Distributors
17879	Textiles, Apparel & Luxury Goods
9844	Distributors
7659	Machinery
7660	Media
17624	Textiles, Apparel & Luxury Goods
7651	Construction & Engineering
10713	Software
10742	Specialty Retail
10763	Hotels, Restaurants & Leisure
10353	Capital Markets
10919	Construction & Engineering
9115	Household Durables
17439	Construction & Engineering
10600	Construction & Engineering
7291	Airlines
7291	Airlines
7661	Charity/Non-Profit
10693	Food & Staples Retailing
7662	Specialty Retail
7663	Professional Services
8735	Trading Companies & Distributors
9684	Professional Services
17445	Construction & Engineering
8734	Hotels, Restaurants & Leisure
16880	Capital Markets
7665	Machinery
8589	Construction & Engineering
7666	Food & Staples Retailing
7666	Food & Staples Retailing
9054	Distributors
9799	Internet & Direct Marketing Retail
7667	Construction & Engineering
7667	Construction & Engineering
7668	Diversified Consumer Services
8590	Building Products
10805	Health Care Providers & Services
7670	Metals & Mining
7671	Chemicals
7671	Chemicals
17631	Textiles, Apparel & Luxury Goods
10956	Commercial Services & Supplies
10263	Specialty Retail
8728	Media
7669	Media
7669	Media
8904	Energy Equipment & Services
7664	Personal Products
9085	Real Estate Management & Development
8318	Food Products
8318	Food Products
10030	Food Products
10930	Commercial Services & Supplies
7652	Distributors
8744	Machinery
10276	Textiles, Apparel & Luxury Goods
10448	Transportation Infrastructure
16966	Internet & Direct Marketing Retail
7672	Specialty Retail
9012	Food & Staples Retailing
8591	Professional Services
7673	Diversified Consumer Services
18526	Professional Services
9377	Tobacco
7653	Construction & Engineering
17220	Diversified Financial Services
8991	Machinery
7674	Capital Markets
8592	Internet Software & Services
10388	Insurance
7675	Oil, Gas & Consumable Fuels
8701	IT Services
9043	Software
9685	Electrical Equipment
7677	Construction & Engineering
7678	IT Services
9831	Real Estate Management & Development
9081	Capital Markets
18462	Media
9536	Personal Products
7679	Diversified Consumer Services
10074	Real Estate Management & Development
17653	Textiles, Apparel & Luxury Goods
8929	Food Products
8929	Food Products
10682	Auto Components
7680	Food Products
10339	Health Care Providers & Services
8915	Metals & Mining
18029	Capital Markets
7681	Diversified Telecommunication Services
7681	Diversified Telecommunication Services
10768	Textiles, Apparel & Luxury Goods
10768	Textiles, Apparel & Luxury Goods
17422	IT Services
7682	Diversified Consumer Services
9723	Food & Staples Retailing
18134	Commercial Services & Supplies
7683	Water Utilities
7684	Construction & Engineering
9425	Construction & Engineering
7685	Food Products
7686	Professional Services
10492	Construction & Engineering
10492	Construction & Engineering
7687	Semiconductors & Semiconductor Equipment
17735	Trading Companies & Distributors
7688	Professional Services
7689	Health Care Providers & Services
10350	Food & Staples Retailing
10531	Hotels, Restaurants & Leisure
7690	Professional Services
7691	Food Products
7692	Textiles, Apparel & Luxury Goods
8593	Software
10403	Food Products
18367	Electronic Equipment, Instruments & Components
7693	Electronic Equipment, Instruments & Components
7693	Electronic Equipment, Instruments & Components
7694	Construction & Engineering
9998	Capital Markets
9998	Capital Markets
17393	Capital Markets
7695	Electronic Equipment, Instruments & Components
7696	Household Products
10596	Professional Services
9024	Air Freight & Logistics
9161	Specialty Retail
8594	Diversified Consumer Services
8594	Diversified Consumer Services
7697	Real Estate Management & Development
10875	Real Estate Management & Development
9392	Beverages
7698	Professional Services
7699	Building Products
7700	Professional Services
7701	Diversified Consumer Services
10864	Commercial Services & Supplies
7702	Food Products
7703	Professional Services
16656	Diversified Consumer Services
17884	Household Durables
16657	Capital Markets
9232	Semiconductors & Semiconductor Equipment
7676	Marine
10043	Media
17654	Building Products
10878	Construction Materials
7704	Real Estate Management & Development
7704	Real Estate Management & Development
9686	Road & Rail
7705	Chemicals
9800	Machinery
7706	Software
9804	Auto Components
9534	Capital Markets
7707	Machinery
7708	Machinery
9872	Machinery
7709	Technology Hardware, Storage & Peripherals
7710	Technology Hardware, Storage & Peripherals
7711	Commercial Services & Supplies
7711	Commercial Services & Supplies
17247	Health Care Equipment & Supplies
9585	Chemicals
18125	Professional Services
7712	Professional Services
7713	Food Products
8759	Chemicals
9022	Commercial Services & Supplies
8867	Machinery
9129	Chemicals
8878	Machinery
9223	Air Freight & Logistics
9499	Hotels, Restaurants & Leisure
10211	Hotels, Restaurants & Leisure
9007	Specialty Retail
7715	Specialty Retail
7716	Distributors
17053	Oil, Gas & Consumable Fuels
9720	Diversified Consumer Services
9795	Professional Services
18176	Auto Components
7717	Electronic Equipment, Instruments & Components
9808	Aerospace & Defense
7290	Personal Products
18547	Health Care Providers & Services
7718	Hotels, Restaurants & Leisure
7719	Commercial Services & Supplies
7719	Commercial Services & Supplies
9509	Commercial Services & Supplies
9760	Commercial Services & Supplies
9760	Commercial Services & Supplies
7720	Food Products
7721	Construction & Engineering
7722	Personal Products
9003	Professional Services
17554	Food Products
17655	Food & Staples Retailing
9128	Energy Equipment & Services
7723	Semiconductors & Semiconductor Equipment
7723	Semiconductors & Semiconductor Equipment
7725	Health Care Providers & Services
7726	Insurance
10119	Health Care Providers & Services
9272	Diversified Consumer Services
8595	Beverages
17555	Auto Components
7729	Electronic Equipment, Instruments & Components
16849	Internet Software & Services
7728	Equity Real Estate Investment Trusts (REITs)
7728	Equity Real Estate Investment Trusts (REITs)
9438	Professional Services
9884	Machinery
9353	Food & Staples Retailing
8596	Chemicals
8596	Chemicals
10413	Household Durables
9730	Hotels, Restaurants & Leisure
9492	Hotels, Restaurants & Leisure
17556	Construction Materials
9011	Commercial Services & Supplies
7730	Distributors
10665	Specialty Retail
10821	Pharmaceuticals
10311	Diversified Consumer Services
10311	Diversified Consumer Services
17222	Diversified Financial Services
10779	Specialty Retail
7731	Diversified Consumer Services
9949	Health Care Providers & Services
7733	Insurance
7733	Insurance
10557	Household Durables
17558	Capital Markets
7734	 Leisure Products
9354	Electrical Equipment
9849	Health Care Providers & Services
10419	Public Entities
10581	Public Entities
9895	Commercial Services & Supplies
18118	Trading Companies & Distributors
10525	Real Estate Management & Development
8773	Consumer Finance
7735	Technology Hardware, Storage & Peripherals
7735	Technology Hardware, Storage & Peripherals
17499	Technology Hardware, Storage & Peripherals
7736	Charity/Non-Profit
7736	Charity/Non-Profit
17676	Electronic Equipment, Instruments & Components
10794	Pharmaceuticals
8879	Diversified Telecommunication Services
9790	Software
8885	Textiles, Apparel & Luxury Goods
9217	Aerospace & Defense
7737	Professional Services
9842	Pharmaceuticals
7732	Food Products
7738	Professional Services
10516	Household Durables
16717	Building Products
8597	Construction Materials
9142	Commercial Services & Supplies
18136	Commercial Services & Supplies
9877	Media
10632	Metals & Mining
10261	Real Estate Management & Development
7739	Insurance
7739	Insurance
16630	Capital Markets
9915	Food & Staples Retailing
9815	Charity/Non-Profit
17493	Hotels, Restaurants & Leisure
16747	Pharmaceuticals
17736	Diversified Consumer Services
18209	Health Care Providers & Services
17026	Road & Rail
17224	Capital Markets
9648	Hotels, Restaurants & Leisure
17656	Machinery
17656	Machinery
7740	Health Care Providers & Services
17361	Commercial Services & Supplies
17361	Commercial Services & Supplies
9185	Independent Power and Renewable Electricity Producers
10368	Trading Companies & Distributors
17657	Food Products
17027	Real Estate Management & Development
18210	Capital Markets
10399	Food Products
8598	Construction & Engineering
7390	Communications Equipment
7741	Charity/Non-Profit
10157	Charity/Non-Profit
10157	Charity/Non-Profit
7742	Professional Services
7743	Containers & Packaging
18208	Food Products
17667	Diversified Financial Services
10265	Media
17795	Capital Markets
7744	Professional Services
9971	Professional Services
7745	Specialty Retail
18491	Food Products
10316	Internet Software & Services
10316	Internet Software & Services
10701	Hotels, Restaurants & Leisure
9195	Diversified Consumer Services
9009	Diversified Consumer Services
10443	Beverages
17855	Commercial Services & Supplies
10503	Specialty Retail
9118	Banks
9118	Banks
18149	Specialty Retail
9974	Food & Staples Retailing
10028	Food & Staples Retailing
16836	Professional Services
10560	Aerospace & Defense
9459	Insurance
10569	Software
17225	Airlines
16866	IT Services
7747	Technology Hardware, Storage & Peripherals
7747	Technology Hardware, Storage & Peripherals
18313	Containers & Packaging
9250	Diversified Consumer Services
9572	Airlines
9076	Transportation Infrastructure
10014	Capital Markets
10743	Equity Real Estate Investment Trusts (REITs)
7748	Diversified Consumer Services
7748	Diversified Consumer Services
7749	Health Care Providers & Services
7750	Diversified Consumer Services
9258	Diversified Consumer Services
7751	Real Estate Management & Development
8599	Capital Markets
8599	Capital Markets
7752	Charity/Non-Profit
7752	Charity/Non-Profit
7753	Food Products
7754	Charity/Non-Profit
17737	Metals & Mining
9398	Industrial Conglomerates
10433	Specialty Retail
7755	Commercial Services & Supplies
9198	Personal Products
18393	Chemicals
18393	Chemicals
9268	Diversified Consumer Services
9268	Diversified Consumer Services
10664	Specialty Retail
18189	Hotels, Restaurants & Leisure
17658	Household Durables
8600	Food & Staples Retailing
7756	Construction Materials
10268	Construction & Engineering
7757	Diversified Financial Services
10015	Professional Services
9645	Real Estate Management & Development
9610	Diversified Consumer Services
7758	Chemicals
17659	Industrial Conglomerates
10667	Textiles, Apparel & Luxury Goods
7759	Personal Products
9381	Distributors
8833	Beverages
17329	Road & Rail
17427	Food Products
9002	Chemicals
16760	Commercial Services & Supplies
8601	Oil, Gas & Consumable Fuels
7783	Pharmaceuticals
7761	Specialty Retail
7762	Hotels, Restaurants & Leisure
9550	Construction & Engineering
7763	Trading Companies & Distributors
18107	Professional Services
7764	Specialty Retail
7765	Charity/Non-Profit
17740	Specialty Retail
7766	Professional Services
18554	Professional Services
9382	Media
17028	Food Products
9794	Capital Markets
9794	Capital Markets
9415	Aerospace & Defense
17739	Household Durables
6970	Marine
18557	Diversified Telecommunication Services
7767	Charity/Non-Profit
7768	Software
16929	Electric Utilities
9607	Insurance
9983	Professional Services
16661	Commercial Services & Supplies
16622	Professional Services
9212	Media
9439	Machinery
17029	Health Care Providers & Services
7769	Road & Rail
7770	Machinery
9237	Pharmaceuticals
7771	Electrical Equipment
10566	Specialty Retail
7772	Commercial Services & Supplies
18517	IT Services
7773	Professional Services
7774	Diversified Consumer Services
7775	Media
17741	Internet & Direct Marketing Retail
10336	Capital Markets
9744	Distributors
17226	Professional Services
9127	Machinery
17227	Diversified Telecommunication Services
17441	Chemicals
17442	Real Estate Management & Development
10278	Health Care Providers & Services
8602	Capital Markets
7776	Capital Markets
7777	Specialty Retail
7478	Health Care Equipment & Supplies
9738	Capital Markets
8603	Construction & Engineering
8603	Construction & Engineering
18248	Metals & Mining
7259	Health Care Providers & Services
9033	Health Care Providers & Services
18108	Commercial Services & Supplies
17228	Air Freight & Logistics
9139	Insurance
17559	Capital Markets
16719	Professional Services
16719	Professional Services
7778	Multiline Retail
7778	Multiline Retail
7779	Electrical Equipment
18331	Capital Markets
8604	Hotels, Restaurants & Leisure
7780	Construction & Engineering
10544	Specialty Retail
18063	Road & Rail
7781	Construction Materials
7781	Construction Materials
17104	Capital Markets
17742	Insurance
8798	Food Products
7782	Commercial Services & Supplies
8605	Hotels, Restaurants & Leisure
10426	Capital Markets
10541	Food & Staples Retailing
10884	Professional Services
7784	Trading Companies & Distributors
7784	Trading Companies & Distributors
18299	Trading Companies & Distributors
9639	Trading Companies & Distributors
17030	Distributors
7785	Machinery
9329	Hotels, Restaurants & Leisure
18235	Building Products
17915	Specialty Retail
18018	Building Products
18018	Building Products
10636	Professional Services
18079	Food Products
9048	Food Products
18020	Software
18020	Software
9151	IT Services
9823	Specialty Retail
8606	Capital Markets
7786	Commercial Services & Supplies
7787	Electronic Equipment, Instruments & Components
9049	Internet Software & Services
7788	Food Products
9848	Trading Companies & Distributors
10034	Diversified Financial Services
7789	Health Care Providers & Services
7789	Health Care Providers & Services
10511	Technology Hardware, Storage & Peripherals
18445	Commercial Services & Supplies
7790	Semiconductors & Semiconductor Equipment
7791	Professional Services
7792	Semiconductors & Semiconductor Equipment
17031	Personal Products
9717	Professional Services
7793	Trading Companies & Distributors
7794	Professional Services
18528	Specialty Retail
8932	Aerospace & Defense
9683	Commercial Services & Supplies
7795	Real Estate Management & Development
7796	Construction & Engineering
7796	Construction & Engineering
10771	Household Products
8834	Household Durables
7797	Food & Staples Retailing
7798	Media
7799	Construction & Engineering
9153	Hotels, Restaurants & Leisure
10464	Professional Services
10898	Professional Services
10835	Construction & Engineering
7800	Professional Services
10258	Diversified Consumer Services
9282	Commercial Services & Supplies
9282	Commercial Services & Supplies
7801	Professional Services
10939	Automobiles
9702	Construction & Engineering
16897	Insurance
7802	Beverages
7803	Aerospace & Defense
7804	Food Products
8758	Commercial Services & Supplies
9551	Health Care Equipment & Supplies
9573	Professional Services
9578	Charity/Non-Profit
17232	Insurance
9526	Commercial Services & Supplies
7805	Health Care Providers & Services
7805	Health Care Providers & Services
7806	Health Care Equipment & Supplies
7807	Health Care Equipment & Supplies
10110	Health Care Providers & Services
17692	Electronic Equipment, Instruments & Components
9874	Aerospace & Defense
10270	Hotels, Restaurants & Leisure
7808	Real Estate Management & Development
7808	Real Estate Management & Development
10744	Electrical Equipment
7809	Textiles, Apparel & Luxury Goods
7809	Textiles, Apparel & Luxury Goods
7810	Media
7811	Software
10694	Specialty Retail
7813	Auto Components
7814	Consumer Finance
10439	Automobiles
7285	Specialty Retail
18341	Professional Services
16910	Pharmaceuticals
10064	Pharmaceuticals
7815	Pharmaceuticals
8732	Oil, Gas & Consumable Fuels
9822	Capital Markets
9468	Health Care Equipment & Supplies
9006	Hotels, Restaurants & Leisure
8950	Real Estate Management & Development
7817	Professional Services
7818	Road & Rail
8963	Construction & Engineering
7819	Metals & Mining
8843	Software
7820	Professional Services
10675	Professional Services
17562	Insurance
18358	Commercial Services & Supplies
7821	Construction & Engineering
10168	Banks
10075	Diversified Telecommunication Services
9788	Real Estate Management & Development
16720	Paper & Forest Products
17859	Machinery
7822	Diversified Financial Services
7822	Diversified Financial Services
17472	Trading Companies & Distributors
18259	Capital Markets
10866	Construction & Engineering
9858	Aerospace & Defense
9706	Professional Services
9380	Commercial Services & Supplies
7823	Charity/Non-Profit
7824	Textiles, Apparel & Luxury Goods
18289	Distributors
9658	Construction & Engineering
8898	Semiconductors & Semiconductor Equipment
7825	Software
7825	Software
9233	Semiconductors & Semiconductor Equipment
9193	Software
9193	Software
7828	Construction & Engineering
7827	Health Care Providers & Services
10553	Food & Staples Retailing
7829	Diversified Consumer Services
9352	Food & Staples Retailing
8777	Hotels, Restaurants & Leisure
10869	Construction & Engineering
7830	Diversified Financial Services
17808	Capital Markets
7831	Hotels, Restaurants & Leisure
7832	Household Durables
7832	Household Durables
18036	IT Services
7833	Professional Services
7834	Household Durables
18465	Diversified Consumer Services
9989	Public Entities
10094	Machinery
10272	Health Care Providers & Services
7835	Charity/Non-Profit
7836	Food & Staples Retailing
7837	Professional Services
10459	Professional Services
7838	Textiles, Apparel & Luxury Goods
7839	Professional Services
7840	Internet & Direct Marketing Retail
7841	Software
9461	Hotels, Restaurants & Leisure
10248	Construction & Engineering
10928	Commercial Services & Supplies
7842	Commercial Services & Supplies
7842	Commercial Services & Supplies
9801	Capital Markets
7843	Trading Companies & Distributors
9902	Industrial Conglomerates
10390	Electrical Equipment
7844	Electrical Equipment
7844	Electrical Equipment
7845	Electrical Equipment
17233	Machinery
9733	Electrical Equipment
7846	Automobiles
7847	Chemicals
7848	Capital Markets
9994	Trading Companies & Distributors
9568	Food Products
10174	Banks
7849	Capital Markets
7850	Capital Markets
7851	Leisure Products
7760	Food Products
18273	Construction & Engineering
17743	Specialty Retail
10323	Semiconductors & Semiconductor Equipment
18555	Commercial Services & Supplies
7260	Real Estate Management & Development
9557	Food & Staples Retailing
18274	Specialty Retail
18459	Distributors
10480	IT Services
7852	Trading Companies & Distributors
8607	Health Care Providers & Services
18050	Health Care Providers & Services
7853	Commercial Services & Supplies
18110	Chemicals
10222	Commercial Services & Supplies
9060	Paper & Forest Products
8736	Capital Markets
10587	Commercial Services & Supplies
10746	Internet Software & Services
18490	Internet Software & Services
18490	Internet Software & Services
18065	Building Products
8781	Commercial Services & Supplies
10707	Food Products
7855	Specialty Retail
7855	Specialty Retail
10392	Beverages
8934	Real Estate Management & Development
10877	Road & Rail
10877	Road & Rail
10765	Capital Markets
7857	Internet Software & Services
7858	Building Products
7856	Professional Services
7856	Professional Services
10747	Machinery
7859	Professional Services
7859	Professional Services
7860	Professional Services
9405	Construction & Engineering
10936	Capital Markets
10547	Food Products
10825	Pharmaceuticals
18241	Capital Markets
7861	Distributors
10012	Hotels, Restaurants & Leisure
9598	Construction & Engineering
8794	Food & Staples Retailing
7862	Consumer Finance
7863	Professional Services
10624	Thrifts & Mortgage Finance
9592	Specialty Retail
7864	Consumer Finance
7865	Multiline Retail
7865	Multiline Retail
7866	Hotels, Restaurants & Leisure
18549	Specialty Retail
8964	Commercial Services & Supplies
7867	Communications Equipment
9065	Professional Services
10703	Food & Staples Retailing
10698	Professional Services
17985	Health Care Providers & Services
7868	Food Products
10037	Specialty Retail
17236	Food Products
17363	Commercial Services & Supplies
17858	Oil, Gas & Consumable Fuels
9435	Insurance
9435	Insurance
10545	Insurance
9297	Capital Markets
7869	Specialty Retail
9976	Professional Services
17034	IT Services
7870	Road & Rail
10640	Road & Rail
8737	Professional Services
7871	Commercial Services & Supplies
16947	Metals & Mining
10601	Capital Markets
7872	Textiles, Apparel & Luxury Goods
9122	Food & Staples Retailing
9429	Containers & Packaging
9124	Construction & Engineering
8782	Chemicals
7873	Household Durables
9136	Insurance
16795	Pharmaceuticals
9378	Pharmaceuticals
17444	Health Care Providers & Services
10656	Electronic Equipment, Instruments & Components
7874	Professional Services
17036	Electric Utilities
16664	Capital Markets
18290	Construction & Engineering
10461	Specialty Retail
10708	Professional Services
9710	Construction Materials
7875	Pharmaceuticals
7877	Media
9330	Internet Software & Services
18072	Trading Companies & Distributors
7878	Hotels, Restaurants & Leisure
9475	Pharmaceuticals
10006	Public Entities
10173	Banks
7879	Charity/Non-Profit
7890	Commercial Services & Supplies
9135	Road & Rail
7880	Commercial Services & Supplies
9112	Charity/Non-Profit
7881	Multi-Utilities
7881	Multi-Utilities
18001	Hotels, Restaurants & Leisure
7906	Construction & Engineering
10549	Media
8897	Distributors
7882	Professional Services
9654	Diversified Financial Services
10067	Charity/Non-Profit
7883	Health Care Providers & Services
7884	Banks
7884	Banks
17860	Capital Markets
7885	Transportation Infrastructure
10065	Professional Services
7886	Leisure Products
18092	Food Products
9850	Specialty Retail
7887	Professional Services
9120	Professional Services
7888	Health Care Providers & Services
7876	Internet & Direct Marketing Retail
7876	Internet & Direct Marketing Retail
7889	IT Services
18047	Industrial Conglomerates
10562	Technology Hardware, Storage & Peripherals
9860	Personal Products
9918	Electrical Equipment
7891	Hotels, Restaurants & Leisure
7891	Hotels, Restaurants & Leisure
16722	Diversified Consumer Services
7892	Construction & Engineering
18354	Insurance
8874	Commercial Services & Supplies
17660	Professional Services
7893	Professional Services
9846	Household Durables
7894	Food Products
7896	Technology Hardware, Storage & Peripherals
9731	Media
7895	Professional Services
8757	Commercial Services & Supplies
10262	Transportation Infrastructure
10266	Textiles, Apparel & Luxury Goods
17237	Thrifts & Mortgage Finance
8608	Diversified Consumer Services
9953	Health Care Providers & Services
17564	Transportation Infrastructure
10078	Media
17446	Commercial Services & Supplies
10148	Health Care Providers & Services
9056	Consumer Finance
8748	Household Durables
10879	Food Products
16851	Transportation Infrastructure
7900	Professional Services
7897	Specialty Retail
7897	Specialty Retail
7898	Professional Services
18496	Metals & Mining
8975	Real Estate Management & Development
7899	Internet Software & Services
10748	Equity Real Estate Investment Trusts (REITs)
7901	Media
7901	Media
17835	Media
18139	Commercial Services & Supplies
10651	Capital Markets
9333	Media
9579	Multiline Retail
9759	Diversified Consumer Services
7903	Air Freight & Logistics
9901	Capital Markets
7904	Professional Services
9830	Construction & Engineering
7905	Auto Components
8609	Health Care Providers & Services
10629	Health Care Providers & Services
7907	Health Care Providers & Services
10780	Health Care Providers & Services
9948	Health Care Providers & Services
9962	Health Care Providers & Services
9939	Health Care Providers & Services
10847	Health Care Providers & Services
8893	Professional Services
10108	Health Care Providers & Services
9967	Health Care Providers & Services
10141	Health Care Providers & Services
10151	Health Care Providers & Services
9952	Health Care Providers & Services
9946	Health Care Providers & Services
10145	Health Care Providers & Services
9937	Health Care Providers & Services
9951	Health Care Providers & Services
7909	Health Care Providers & Services
18431	Health Care Providers & Services
10112	Health Care Providers & Services
7910	Health Care Providers & Services
18497	Real Estate Management & Development
10104	Health Care Providers & Services
9935	Health Care Providers & Services
9938	Health Care Providers & Services
10111	Health Care Providers & Services
10109	Health Care Providers & Services
17762	Health Care Providers & Services
10128	Health Care Providers & Services
10114	Health Care Providers & Services
9776	Banks
17566	Software
17809	Oil, Gas & Consumable Fuels
18361	Oil, Gas & Consumable Fuels
9678	Building Products
10955	Media
7911	Food & Staples Retailing
9064	Professional Services
7912	Machinery
9537	Distributors
9537	Distributors
7913	Household Durables
7913	Household Durables
7914	Electronic Equipment, Instruments & Components
10254	Household Durables
9215	Textiles, Apparel & Luxury Goods
7915	Software
17503	Air Freight & Logistics
18265	Containers & Packaging
7945	Building Products
7945	Building Products
7247	Food & Staples Retailing
9447	Trading Companies & Distributors
9450	Specialty Retail
7916	Household Durables
9748	Media
9806	Aerospace & Defense
16850	Household Durables
10674	Hotels, Restaurants & Leisure
7917	Energy Equipment & Services
7918	Food Products
8859	Trading Companies & Distributors
9146	Communications Equipment
8610	Food Products
7919	Capital Markets
7922	Capital Markets
7921	Capital Markets
7921	Capital Markets
7923	Electrical Equipment
10814	Pharmaceuticals
7924	Building Products
7925	Machinery
7926	Health Care Providers & Services
10807	Pharmaceuticals
7927	Banks
7927	Banks
10699	Chemicals
8611	Chemicals
7928	Commercial Services & Supplies
7929	Commercial Services & Supplies
7929	Commercial Services & Supplies
9091	Metals & Mining
10103	Health Care Providers & Services
10149	Health Care Providers & Services
9749	Beverages
10081	Health Care Providers & Services
10245	Specialty Retail
8812	Media
7931	Banks
10127	Health Care Providers & Services
7932	Gas Utilities
7933	Electric Utilities
7933	Electric Utilities
7934	Water Utilities
8763	Electric Utilities
8868	Banks
8868	Banks
7935	Road & Rail
7936	IT Services
7930	Construction & Engineering
10677	Insurance
17642	Commercial Services & Supplies
17568	Aerospace & Defense
10232	Health Care Providers & Services
10115	Health Care Providers & Services
10133	Health Care Providers & Services
10118	Health Care Providers & Services
10118	Health Care Providers & Services
7938	Water Utilities
7938	Water Utilities
7937	Diversified Consumer Services
7937	Diversified Consumer Services
10826	Health Care Providers & Services
9940	Health Care Providers & Services
9532	Diversified Consumer Services
7939	Professional Services
7939	Professional Services
9642	Specialty Retail
9642	Specialty Retail
9642	Specialty Retail
9816	Hotels, Restaurants & Leisure
9247	Oil, Gas & Consumable Fuels
9745	Household Durables
10565	Internet & Direct Marketing Retail
9078	Banks
9732	Health Care Providers & Services
9732	Health Care Providers & Services
7940	Public Entities
7941	Air Freight & Logistics
7942	Charity/Non-Profit
9523	Public Entities
10154	Health Care Providers & Services
9267	Diversified Consumer Services
9286	Health Care Providers & Services
7943	Electronic Equipment, Instruments & Components
9977	Pharmaceuticals
9977	Pharmaceuticals
10487	Pharmaceuticals
9114	Chemicals
9641	Construction & Engineering
9130	Electric Utilities
7944	Real Estate Management & Development
18390	IT Services
7946	Machinery
7947	Commercial Services & Supplies
9886	Diversified Telecommunication Services
10024	Hotels, Restaurants & Leisure
10063	Diversified Telecommunication Services
7948	IT Services
7949	IT Services
7950	IT Services
18508	Machinery
7951	Diversified Telecommunication Services
8847	Health Care Providers & Services
9296	Health Care Providers & Services
7952	Food Products
10288	Food Products
10410	Technology Hardware, Storage & Peripherals
7953	Oil, Gas & Consumable Fuels
7953	Oil, Gas & Consumable Fuels
9234	Semiconductors & Semiconductor Equipment
7954	Health Care Equipment & Supplies
8612	Household Durables
7955	Health Care Providers & Services
9856	Textiles, Apparel & Luxury Goods
17834	Media
10859	Construction & Engineering
7956	Internet & Direct Marketing Retail
7956	Internet & Direct Marketing Retail
9423	Food Products
7957	Commercial Services & Supplies
9713	Capital Markets
10317	Professional Services
7958	Internet Software & Services
18272	Capital Markets
9319	Professional Services
9754	Commercial Services & Supplies
7959	Specialty Retail
7959	Specialty Retail
7960	Commercial Services & Supplies
9644	Commercial Services & Supplies
10301	Oil, Gas & Consumable Fuels
8806	Insurance
8806	Insurance
18314	Professional Services
7961	Food & Staples Retailing
7962	Food Products
9396	Health Care Equipment & Supplies
7963	Diversified Financial Services
7964	Household Durables
17336	Chemicals
10070	Media
9803	Electronic Equipment, Instruments & Components
10358	Oil, Gas & Consumable Fuels
7965	Chemicals
7965	Chemicals
8614	Containers & Packaging
7966	Professional Services
8613	Charity/Non-Profit
8722	Construction & Engineering
9917	Banks
16808	Real Estate Management & Development
7967	Real Estate Management & Development
7967	Real Estate Management & Development
9235	Semiconductors & Semiconductor Equipment
7968	Food Products
7971	Food & Staples Retailing
7969	Internet Software & Services
17573	Internet Software & Services
17573	Internet Software & Services
18188	IT Services
7970	Diversified Consumer Services
7972	Technology Hardware, Storage & Peripherals
8615	Oil, Gas & Consumable Fuels
9626	Internet & Direct Marketing Retail
17620	Consumer Finance
10695	Machinery
17487	Trading Companies & Distributors
8927	Construction & Engineering
17976	Specialty Retail
7973	Professional Services
9602	Technology Hardware, Storage & Peripherals
9781	Health Care Equipment & Supplies
9781	Health Care Equipment & Supplies
7974	Health Care Providers & Services
7975	Gas Utilities
7976	Software
10354	Commercial Services & Supplies
18111	Diversified Financial Services
7977	Machinery
18349	Diversified Telecommunication Services
17238	Capital Markets
17466	Electronic Equipment, Instruments & Components
9634	Food Products
9634	Food Products
7978	Media
10076	Multiline Retail
7979	Charity/Non-Profit
10495	Chemicals
18180	Professional Services
9591	Food Products
7980	Machinery
9325	Professional Services
8982	Health Care Equipment & Supplies
17447	Professional Services
7981	Professional Services
7981	Professional Services
9990	Food Products
9545	Electrical Equipment
8239	Specialty Retail
16932	Machinery
17745	Pharmaceuticals
7982	Capital Markets
9469	Professional Services
10171	Banks
7983	Health Care Providers & Services
10571	Capital Markets
7984	Professional Services
17042	Diversified Financial Services
7985	Building Products
7986	Charity/Non-Profit
7986	Charity/Non-Profit
7987	Diversified Consumer Services
7988	Health Care Providers & Services
7989	Electronic Equipment, Instruments & Components
7989	Electronic Equipment, Instruments & Components
10848	Professional Services
7990	Media
7990	Media
17856	Insurance
17241	Professional Services
17241	Professional Services
10889	Construction & Engineering
8616	Hotels, Restaurants & Leisure
9055	Professional Services
10681	Media
18344	Distributors
9687	Professional Services
9627	Road & Rail
9448	Electrical Equipment
9366	Electronic Equipment, Instruments & Components
9366	Electronic Equipment, Instruments & Components
7991	Textiles, Apparel & Luxury Goods
17567	Machinery
9066	Capital Markets
9467	Specialty Retail
10229	Charity/Non-Profit
8816	Charity/Non-Profit
18539	Banks
10603	Commercial Services & Supplies
9876	Banks
16667	Construction & Engineering
7992	Household Durables
7993	Food Products
17337	Hotels, Restaurants & Leisure
18292	Specialty Retail
9512	Machinery
7994	Specialty Retail
9704	Hotels, Restaurants & Leisure
9928	Electronic Equipment, Instruments & Components
7995	IT Services
17449	Electronic Equipment, Instruments & Components
8198	Real Estate Management & Development
7996	Distributors
18301	Capital Markets
9606	Textiles, Apparel & Luxury Goods
17569	Pharmaceuticals
8617	Charity/Non-Profit
7997	Health Care Providers & Services
7998	Hotels, Restaurants & Leisure
9802	Health Care Providers & Services
7999	Aerospace & Defense
17114	Health Care Equipment & Supplies
8000	Professional Services
8001	Specialty Retail
9574	Specialty Retail
8003	Commercial Services & Supplies
8618	IT Services
8004	Professional Services
8005	Life Sciences Tools & Services
18212	Commercial Services & Supplies
8006	Software
8007	Food Products
8007	Food Products
10022	Distributors
8008	Energy Equipment & Services
18359	Transportation Infrastructure
9991	Aerospace & Defense
8619	Media
8009	Real Estate Management & Development
10712	Capital Markets
10523	Software
17043	Household Durables
8010	Food Products
17854	Insurance
10679	Textiles, Apparel & Luxury Goods
8011	Specialty Retail
8620	Media
8620	Media
8012	Professional Services
8012	Professional Services
9363	Oil, Gas & Consumable Fuels
10338	Professional Services
10105	Health Care Providers & Services
9936	Health Care Providers & Services
8013	Professional Services
8013	Professional Services
8014	Water Utilities
9045	Insurance
8836	Capital Markets
9401	IT Services
17245	Specialty Retail
10246	Machinery
9373	Marine
9143	Textiles, Apparel & Luxury Goods
8621	Specialty Retail
10929	Professional Services
8622	Thrifts & Mortgage Finance
9542	Food Products
8015	Construction & Engineering
18552	Media
17912	Construction & Engineering
17570	Machinery
8848	Construction & Engineering
18112	Professional Services
8016	Beverages
8016	Beverages
10496	Pharmaceuticals
10496	Pharmaceuticals
8017	Textiles, Apparel & Luxury Goods
8017	Textiles, Apparel & Luxury Goods
8623	Household Durables
8623	Household Durables
10816	Commercial Services & Supplies
9070	Professional Services
9070	Professional Services
10023	Charity/Non-Profit
9540	Public Entities
17452	Construction & Engineering
10717	Distributors
18080	Capital Markets
10648	Metals & Mining
9030	Energy Equipment & Services
18213	Software
17318	Independent Power and Renewable Electricity Producers
17045	Metals & Mining
8018	Specialty Retail
8018	Specialty Retail
10563	Food & Staples Retailing
16930	Specialty Retail
10789	Pharmaceuticals
8019	Hotels, Restaurants & Leisure
10804	Pharmaceuticals
8020	Textiles, Apparel & Luxury Goods
8020	Textiles, Apparel & Luxury Goods
10849	Construction & Engineering
10504	Paper & Forest Products
16724	Distributors
17571	Electrical Equipment
10959	Oil, Gas & Consumable Fuels
8021	Electric Utilities
8021	Electric Utilities
10954	Insurance
9647	Electronic Equipment, Instruments & Components
10803	Health Care Providers & Services
16933	Electrical Equipment
9853	Health Care Technology
9824	IT Services
10412	Media
8022	Internet Software & Services
9742	Road & Rail
9113	Professional Services
17861	Capital Markets
17310	Media
10180	Insurance
8023	Professional Services
8023	Professional Services
8024	Specialty Retail
18177	Auto Components
10661	Commercial Services & Supplies
10661	Commercial Services & Supplies
8712	Hotels, Restaurants & Leisure
10039	Hotels, Restaurants & Leisure
18293	Distributors
8025	Real Estate Management & Development
9767	Charity/Non-Profit
8026	Trading Companies & Distributors
10749	Software
8027	Electronic Equipment, Instruments & Components
9724	Professional Services
17046	Oil, Gas & Consumable Fuels
8028	Diversified Telecommunication Services
8624	Commercial Services & Supplies
10833	Household Durables
17047	Professional Services
10654	Distributors
8029	Marine
17956	Communications Equipment
8030	Commercial Services & Supplies
8625	Building Products
8625	Building Products
10451	Insurance
8844	Professional Services
17453	Charity/Non-Profit
10430	Specialty Retail
8031	Construction & Engineering
8837	Trading Companies & Distributors
17050	Hotels, Restaurants & Leisure
8627	Hotels, Restaurants & Leisure
8626	Transportation Infrastructure
10915	Marine
17049	Construction & Engineering
8032	Water Utilities
17661	Machinery
9389	Commercial Services & Supplies
9371	Air Freight & Logistics
9371	Air Freight & Logistics
8628	Multiline Retail
8034	Multiline Retail
8034	Multiline Retail
8035	Food & Staples Retailing
10073	Electric Utilities
18081	Professional Services
9152	Professional Services
8036	Professional Services
9321	Chemicals
17937	Chemicals
9337	Professional Services
10515	Textiles, Apparel & Luxury Goods
8037	Life Sciences Tools & Services
16822	Oil, Gas & Consumable Fuels
17454	Aerospace & Defense
8038	Commercial Services & Supplies
17977	Leisure Products
9508	Insurance
8040	Capital Markets
8040	Capital Markets
9721	Food Products
8041	Oil, Gas & Consumable Fuels
16796	Trading Companies & Distributors
8058	Commercial Services & Supplies
8988	Consumer Finance
10181	Consumer Finance
10475	Media
18502	Energy Equipment & Services
9587	Professional Services
17908	Distributors
17622	Insurance
8042	Professional Services
8042	Professional Services
16934	Distributors
8800	Specialty Retail
8800	Specialty Retail
8043	Equity Real Estate Investment Trusts (REITs)
8044	Metals & Mining
8045	Construction & Engineering
18115	Metals & Mining
8046	Food & Staples Retailing
8046	Food & Staples Retailing
17687	Machinery
9603	Charity/Non-Profit
18035	Banks
8047	Auto Components
16753	IT Services
9463	Electronic Equipment, Instruments & Components
8711	Containers & Packaging
17964	Household Products
8050	Personal Products
8838	Food Products
8051	Food Products
8051	Food Products
9912	Diversified Financial Services
9913	Trading Companies & Distributors
16887	Hotels, Restaurants & Leisure
8048	Professional Services
8052	Charity/Non-Profit
9893	Real Estate Management & Development
10247	Professional Services
8053	Professional Services
10942	Professional Services
18317	Mortgage Real Estate Investment Trusts (REITs)
10467	Diversified Consumer Services
17051	Distributors
8054	IT Services
8055	Diversified Consumer Services
18022	Electrical Equipment
17810	Diversified Consumer Services
8056	Consumer Finance
8056	Consumer Finance
17366	Media
8057	Metals & Mining
8901	Insurance
17126	Commercial Services & Supplies
18186	Diversified Financial Services
18544	Professional Services
10634	Oil, Gas & Consumable Fuels
9359	Textiles, Apparel & Luxury Goods
9595	Hotels, Restaurants & Leisure
10639	Banks
10750	Food Products
8922	Hotels, Restaurants & Leisure
8059	Hotels, Restaurants & Leisure
8060	Household Products
9340	Electronic Equipment, Instruments & Components
8061	Airlines
8061	Airlines
18143	Banks
9473	Insurance
10618	Pharmaceuticals
17819	Media
16777	Life Sciences Tools & Services
8062	Aerospace & Defense
8063	Software
17249	Commercial Services & Supplies
10343	Construction & Engineering
17251	Capital Markets
8940	Semiconductors & Semiconductor Equipment
8064	Textiles, Apparel & Luxury Goods
9240	Pharmaceuticals
10129	Health Care Providers & Services
9421	Diversified Consumer Services
8065	Diversified Consumer Services
9931	Hotels, Restaurants & Leisure
17250	Hotels, Restaurants & Leisure
10644	Professional Services
17326	Construction & Engineering
16668	Real Estate Management & Development
9611	Beverages
17455	Hotels, Restaurants & Leisure
8066	Food Products
8067	Specialty Retail
8067	Specialty Retail
10058	Internet Software & Services
9205	Professional Services
8068	Commercial Services & Supplies
17747	Professional Services
10722	Consumer Finance
8069	Textiles, Apparel & Luxury Goods
8127	Transportation Infrastructure
9615	Electronic Equipment, Instruments & Components
10456	Textiles, Apparel & Luxury Goods
8070	Health Care Providers & Services
18448	Consumer Finance
10791	Health Care Providers & Services
17395	Food Products
8071	Insurance
8071	Insurance
10913	Metals & Mining
8072	Professional Services
8073	Hotels, Restaurants & Leisure
8073	Hotels, Restaurants & Leisure
16655	Machinery
9569	Textiles, Apparel & Luxury Goods
9747	Capital Markets
9400	Trading Companies & Distributors
9400	Trading Companies & Distributors
17256	Construction & Engineering
17256	Construction & Engineering
8074	Construction & Engineering
18214	Electrical Equipment
8076	Trading Companies & Distributors
17325	Professional Services
17796	Media
17456	Internet & Direct Marketing Retail
17054	Food Products
8077	Food Products
16824	Health Care Providers & Services
10576	Software
8630	Household Products
10184	Diversified Financial Services
17457	Commercial Services & Supplies
17264	Professional Services
17055	Media
8078	Beverages
8081	Capital Markets
8082	IT Services
10554	Professional Services
8860	Commercial Services & Supplies
8083	Road & Rail
8083	Road & Rail
9930	Hotels, Restaurants & Leisure
9930	Hotels, Restaurants & Leisure
18512	Real Estate Management & Development
10751	Real Estate Management & Development
9655	Internet Software & Services
9099	Marine
8079	Real Estate Management & Development
8080	Charity/Non-Profit
9997	Professional Services
8084	Household Durables
17396	Capital Markets
17396	Capital Markets
10607	Hotels, Restaurants & Leisure
8699	Professional Services
8699	Professional Services
17576	Professional Services
8085	Trading Companies & Distributors
9208	Textiles, Apparel & Luxury Goods
8086	Charity/Non-Profit
18135	Gas Utilities
9251	Diversified Consumer Services
18551	Diversified Consumer Services
8096	Professional Services
8087	Real Estate Management & Development
16726	Chemicals
10050	Electrical Equipment
10050	Electrical Equipment
10556	Textiles, Apparel & Luxury Goods
8951	Media
8951	Media
16935	Household Durables
17252	Capital Markets
17749	Commercial Services & Supplies
17797	Professional Services
17056	Specialty Retail
16920	Machinery
8088	Specialty Retail
9612	Electrical Equipment
10752	Independent Power and Renewable Electricity Producers
10753	Commercial Services & Supplies
10753	Commercial Services & Supplies
8089	Electronic Equipment, Instruments & Components
8089	Electronic Equipment, Instruments & Components
8090	Machinery
9350	Specialty Retail
8631	Commercial Services & Supplies
8631	Commercial Services & Supplies
17076	Oil, Gas & Consumable Fuels
10093	Media
9789	Professional Services
8865	Independent Power and Renewable Electricity Producers
8091	Commercial Services & Supplies
8092	Professional Services
17254	Professional Services
8700	Hotels, Restaurants & Leisure
17057	Commercial Services & Supplies
9086	Professional Services
17255	Professional Services
9446	Distributors
9096	Capital Markets
10322	Trading Companies & Distributors
8093	Food & Staples Retailing
8094	Professional Services
8095	Hotels, Restaurants & Leisure
17898	Media
8880	Construction & Engineering
9339	Construction & Engineering
9774	Air Freight & Logistics
8097	Food & Staples Retailing
8097	Food & Staples Retailing
10754	Construction Materials
17272	Textiles, Apparel & Luxury Goods
16669	Hotels, Restaurants & Leisure
8098	Hotels, Restaurants & Leisure
8098	Hotels, Restaurants & Leisure
8099	Professional Services
8099	Professional Services
9812	Food & Staples Retailing
8100	Specialty Retail
8101	Charity/Non-Profit
9805	Technology Hardware, Storage & Peripherals
9805	Technology Hardware, Storage & Peripherals
10478	Air Freight & Logistics
16863	Construction & Engineering
8102	Specialty Retail
9769	Diversified Financial Services
10755	Internet Software & Services
10755	Internet Software & Services
17313	Distributors
9926	Professional Services
18476	Software
17913	Beverages
10865	Construction & Engineering
8103	Metals & Mining
8103	Metals & Mining
9896	Technology Hardware, Storage & Peripherals
8104	Capital Markets
8104	Capital Markets
8632	Food Products
17128	Specialty Retail
8105	Charity/Non-Profit
17577	Road & Rail
10295	Oil, Gas & Consumable Fuels
8740	Construction & Engineering
18472	Construction & Engineering
17257	Electrical Equipment
8106	Software
17578	Charity/Non-Profit
17160	Electrical Equipment
9743	Capital Markets
9276	Diversified Consumer Services
9119	Professional Services
8108	Construction & Engineering
18043	Professional Services
8107	Construction & Engineering
18413	Food Products
17397	Distributors
17086	Building Products
9493	Hotels, Restaurants & Leisure
8109	Charity/Non-Profit
8109	Charity/Non-Profit
9739	Pharmaceuticals
16798	Electrical Equipment
10945	Aerospace & Defense
10945	Aerospace & Defense
17260	Food & Staples Retailing
17811	Professional Services
10519	Communications Equipment
8110	Semiconductors & Semiconductor Equipment
8111	Leisure Products
8112	Leisure Products
17579	Automobiles
8952	Aerospace & Defense
8952	Aerospace & Defense
10432	Metals & Mining
10579	Specialty Retail
9342	Internet Software & Services
8114	Charity/Non-Profit
8633	Distributors
17978	Food Products
18275	Household Durables
8115	Construction & Engineering
18540	Road & Rail
9452	Machinery
8116	Trading Companies & Distributors
10113	Health Care Providers & Services
9036	Insurance
8117	Capital Markets
9150	Machinery
9150	Machinery
8118	Energy Equipment & Services
8634	Construction & Engineering
9847	Commercial Services & Supplies
10770	Charity/Non-Profit
18233	Hotels, Restaurants & Leisure
8721	Banks
8075	Banks
10139	Health Care Providers & Services
10139	Health Care Providers & Services
9173	Hotels, Restaurants & Leisure
8119	Diversified Consumer Services
8924	Oil, Gas & Consumable Fuels
8924	Oil, Gas & Consumable Fuels
18083	Food Products
8120	Diversified Consumer Services
9863	Charity/Non-Profit
10933	Professional Services
8121	Health Care Providers & Services
8122	Insurance
8122	Insurance
10004	Air Freight & Logistics
8123	Health Care Providers & Services
8123	Health Care Providers & Services
10776	Charity/Non-Profit
6900	Charity/Non-Profit
10415	Charity/Non-Profit
10214	Charity/Non-Profit
8635	Charity/Non-Profit
9285	Diversified Consumer Services
16871	Charity/Non-Profit
18023	Food & Staples Retailing
8125	Containers & Packaging
9462	Commercial Services & Supplies
9369	Commercial Services & Supplies
8126	Specialty Retail
8953	Insurance
8953	Insurance
17059	Commercial Services & Supplies
9624	Professional Services
9614	Professional Services
10564	Road & Rail
9882	Professional Services
17669	Air Freight & Logistics
10470	Industrial Conglomerates
10359	Textiles, Apparel & Luxury Goods
9650	Capital Markets
8839	Textiles, Apparel & Luxury Goods
8128	Professional Services
16826	Food Products
17691	Capital Markets
8129	Construction & Engineering
17398	Distributors
9361	Professional Services
18159	Construction & Engineering
17263	Capital Markets
8755	Independent Power and Renewable Electricity Producers
18066	Commercial Services & Supplies
18494	Commercial Services & Supplies
17368	Automobiles
17348	Air Freight & Logistics
17060	Construction & Engineering
8130	Specialty Retail
8131	Trading Companies & Distributors
18061	Multiline Retail
8636	Aerospace & Defense
8636	Aerospace & Defense
8133	Chemicals
8133	Chemicals
16876	IT Services
8134	Beverages
17580	Beverages
9616	Insurance
8135	Specialty Retail
8135	Specialty Retail
8693	Hotels, Restaurants & Leisure
18053	Household Products
10907	Commercial Services & Supplies
8637	Building Products
16827	Commercial Services & Supplies
18067	Aerospace & Defense
9490	Insurance
9565	Insurance
8136	Software
8136	Software
9303	Media
16915	Food Products
18276	Diversified Financial Services
17062	Containers & Packaging
9013	Banks
8822	Building Products
8822	Building Products
9176	Energy Equipment & Services
16853	Software
8138	Health Care Providers & Services
9793	Diversified Financial Services
18004	Health Care Equipment & Supplies
10420	Charity/Non-Profit
8139	Charity/Non-Profit
8139	Charity/Non-Profit
17265	Textiles, Apparel & Luxury Goods
9094	Household Durables
8140	Electronic Equipment, Instruments & Components
17606	Food Products
8141	Charity/Non-Profit
8840	Professional Services
8142	Construction & Engineering
8143	Specialty Retail
10692	Public Entities
16639	Professional Services
16854	Insurance
10756	Capital Markets
10812	Pharmaceuticals
9866	Banks
17330	IT Services
8638	Capital Markets
18049	Food Products
17121	Building Products
7812	Software
9651	Media
17064	Multiline Retail
8810	Charity/Non-Profit
10208	Charity/Non-Profit
8639	Real Estate Management & Development
18234	Household Durables
10772	Trading Companies & Distributors
9214	Food & Staples Retailing
8144	Paper & Forest Products
10196	Machinery
17581	Professional Services
8145	Chemicals
8146	Media
16645	Road & Rail
10394	Trading Companies & Distributors
17501	Commercial Services & Supplies
17582	Machinery
8882	Air Freight & Logistics
9402	Machinery
10234	Electrical Equipment
10234	Electrical Equipment
8148	Media
8149	Capital Markets
8149	Capital Markets
16901	Household Durables
17065	Specialty Retail
8889	Professional Services
10097	Hotels, Restaurants & Leisure
10723	Electrical Equipment
8150	IT Services
18215	Household Products
8151	Electrical Equipment
8152	Charity/Non-Profit
9677	Food Products
10284	Household Products
10290	Diversified Consumer Services
9292	Diversified Consumer Services
10341	Chemicals
17267	Air Freight & Logistics
17268	Capital Markets
8154	Textiles, Apparel & Luxury Goods
8768	Food & Staples Retailing
8906	Electric Utilities
8155	Media
8156	Food Products
10041	Water Utilities
8157	Water Utilities
8157	Water Utilities
8158	Paper & Forest Products
8153	Media
16870	Specialty Retail
16780	Construction & Engineering
10904	Media
8747	Software
16893	Real Estate Management & Development
16670	Trading Companies & Distributors
8159	Food & Staples Retailing
8159	Food & Staples Retailing
17461	Diversified Financial Services
8160	Energy Equipment & Services
8160	Energy Equipment & Services
9466	Containers & Packaging
8640	Textiles, Apparel & Luxury Goods
8640	Textiles, Apparel & Luxury Goods
9090	Automobiles
9676	Household Durables
8161	Banks
8161	Banks
17752	Capital Markets
8641	Commercial Services & Supplies
8642	Capital Markets
8162	Professional Services
18216	Diversified Financial Services
7248	Software
7248	Software
10083	Equity Real Estate Investment Trusts (REITs)
16869	Capital Markets
8163	Software
17462	Internet & Direct Marketing Retail
9750	Commercial Services & Supplies
17891	Real Estate Management & Development
8164	Multiline Retail
8165	Commercial Services & Supplies
16728	Professional Services
10573	Real Estate Management & Development
8166	Electric Utilities
8643	Aerospace & Defense
17686	Electrical Equipment
18569	Auto Components
16729	Charity/Non-Profit
16872	Chemicals
8167	Charity/Non-Profit
8168	Communications Equipment
16730	Real Estate Management & Development
9083	Commercial Services & Supplies
8169	Professional Services
8170	Electronic Equipment, Instruments & Components
8171	Commercial Services & Supplies
8171	Commercial Services & Supplies
17753	Commercial Services & Supplies
9481	IT Services
16937	Professional Services
10463	Health Care Providers & Services
17498	Capital Markets
8842	Capital Markets
8172	Construction & Engineering
8644	Water Utilities
8644	Water Utilities
18087	Commercial Services & Supplies
17122	Capital Markets
17862	Machinery
8173	Commercial Services & Supplies
10641	Banks
10891	Professional Services
8174	Communications Equipment
8175	Equity Real Estate Investment Trusts (REITs)
8175	Equity Real Estate Investment Trusts (REITs)
8176	Professional Services
8177	Commercial Services & Supplies
17072	Commercial Services & Supplies
8178	Electronic Equipment, Instruments & Components
9879	Banks
16938	Health Care Providers & Services
8179	Construction & Engineering
18237	Internet Software & Services
8180	Diversified Consumer Services
8180	Diversified Consumer Services
17271	Hotels, Restaurants & Leisure
9059	Professional Services
10159	Metals & Mining
8181	Diversified Consumer Services
9945	Health Care Providers & Services
8182	Health Care Providers & Services
8183	Professional Services
8184	Beverages
8185	Real Estate Management & Development
17623	Chemicals
10552	Chemicals
10630	Professional Services
9063	Electronic Equipment, Instruments & Components
17934	Leisure Products
8186	Electronic Equipment, Instruments & Components
8187	Insurance
8954	Biotechnology
18369	Hotels, Restaurants & Leisure
17754	Specialty Retail
8189	Professional Services
8189	Professional Services
8190	Internet & Direct Marketing Retail
8190	Internet & Direct Marketing Retail
9111	Aerospace & Defense
18056	Machinery
9943	Health Care Providers & Services
8191	Food Products
9341	Textiles, Apparel & Luxury Goods
10321	Banks
10374	Diversified Financial Services
10383	Electrical Equipment
10373	Health Care Technology
10375	IT Services
10378	Electrical Equipment
10376	IT Services
8192	Machinery
10379	Air Freight & Logistics
10380	Electrical Equipment
10381	Road & Rail
10382	Electrical Equipment
8849	Charity/Non-Profit
17314	Food Products
9772	Specialty Retail
10757	Trading Companies & Distributors
8193	Aerospace & Defense
17464	Household Durables
10242	Semiconductors & Semiconductor Equipment
10019	Banks
8194	Electronic Equipment, Instruments & Components
10302	Food Products
10302	Food Products
8195	Industrial Conglomerates
8196	Professional Services
8197	Construction & Engineering
18287	Internet Software & Services
8199	Insurance
10555	Food Products
10418	Transportation Infrastructure
10863	Construction & Engineering
9652	Commercial Services & Supplies
10061	Professional Services
18340	Construction Materials
17625	Equity Real Estate Investment Trusts (REITs)
17584	Charity/Non-Profit
8201	Construction & Engineering
9489	Communications Equipment
17756	Construction & Engineering
10922	Internet Software & Services
16634	Commercial Services & Supplies
18095	Commercial Services & Supplies
8983	IT Services
9095	Construction & Engineering
18187	Food Products
17963	Specialty Retail
16864	Machinery
17757	Thrifts & Mortgage Finance
9177	Hotels, Restaurants & Leisure
8202	Media
8202	Media
10098	Semiconductors & Semiconductor Equipment
8203	Professional Services
8204	Professional Services
8204	Professional Services
8205	Food & Staples Retailing
8132	Professional Services
8206	Commercial Services & Supplies
10269	Software
8208	Electric Utilities
8778	Electronic Equipment, Instruments & Components
10079	Professional Services
8207	Professional Services
9695	Professional Services
16865	Specialty Retail
8209	Hotels, Restaurants & Leisure
8955	Health Care Equipment & Supplies
18085	Commercial Services & Supplies
8211	Industrial Conglomerates
8211	Industrial Conglomerates
18024	Trading Companies & Distributors
8210	Diversified Financial Services
9137	Containers & Packaging
17812	Specialty Retail
16745	Specialty Retail
9487	Professional Services
17061	Metals & Mining
9548	Specialty Retail
17069	Trading Companies & Distributors
8212	Diversified Consumer Services
8212	Diversified Consumer Services
10550	Diversified Financial Services
8928	Internet Software & Services
8645	Oil, Gas & Consumable Fuels
8213	Hotels, Restaurants & Leisure
8213	Hotels, Restaurants & Leisure
18086	Machinery
16873	Paper & Forest Products
16873	Paper & Forest Products
8214	IT Services
17903	Electronic Equipment, Instruments & Components
9959	Health Care Providers & Services
9576	Software
10444	Chemicals
16884	Distributors
10622	Charity/Non-Profit
9954	Health Care Providers & Services
8215	Insurance
8216	Electronic Equipment, Instruments & Components
8217	Household Durables
8217	Household Durables
8218	Software
9320	Software
9320	Software
16732	Software
10422	Diversified Consumer Services
8647	Metals & Mining
8647	Metals & Mining
18365	Media
9280	Diversified Consumer Services
16874	Specialty Retail
16904	Electric Utilities
16778	Water Utilities
10649	Electronic Equipment, Instruments & Components
8884	Food & Staples Retailing
9832	Real Estate Management & Development
8223	Diversified Consumer Services
9601	Water Utilities
9963	Health Care Providers & Services
17070	Oil, Gas & Consumable Fuels
8646	Oil, Gas & Consumable Fuels
9964	Health Care Providers & Services
8220	Water Utilities
8221	Health Care Providers & Services
8221	Health Care Providers & Services
17585	Commercial Services & Supplies
16775	Health Care Providers & Services
8761	Charity/Non-Profit
10706	Charity/Non-Profit
8224	Professional Services
8224	Professional Services
10830	Construction & Engineering
10786	Electric Utilities
10048	Energy Equipment & Services
9988	Food Products
8147	IT Services
17071	Professional Services
18140	Leisure Products
9478	Health Care Equipment & Supplies
8225	Electronic Equipment, Instruments & Components
18568	Professional Services
8226	Trading Companies & Distributors
9561	Household Durables
8227	Professional Services
17602	Professional Services
10259	Commercial Services & Supplies
9332	Electronic Equipment, Instruments & Components
8228	Machinery
8228	Machinery
8228	Machinery
10449	Health Care Providers & Services
17758	Technology Hardware, Storage & Peripherals
17758	Technology Hardware, Storage & Peripherals
17465	Aerospace & Defense
16805	Software
8229	Specialty Retail
8229	Specialty Retail
8899	Media
8230	Professional Services
8231	Software
8790	Software
8232	Software
8233	Professional Services
8234	Professional Services
17274	Professional Services
8235	Professional Services
8236	Electric Utilities
8236	Electric Utilities
18546	Construction & Engineering
8237	Hotels, Restaurants & Leisure
8237	Hotels, Restaurants & Leisure
8238	Software
8200	Professional Services
9758	Professional Services
8247	Road & Rail
8247	Road & Rail
10650	Building Products
17467	Pharmaceuticals
17586	Banks
8779	Banks
8779	Banks
9871	Insurance
8248	Insurance
8249	Charity/Non-Profit
10279	Machinery
18277	Multi-Utilities
18321	Machinery
8250	Construction Materials
9751	Distributors
8251	Banks
8762	Specialty Retail
9038	Food Products
8648	Capital Markets
8252	Communications Equipment
17277	Independent Power and Renewable Electricity Producers
8916	Oil, Gas & Consumable Fuels
8916	Oil, Gas & Consumable Fuels
10335	Beverages
8253	Commercial Services & Supplies
8253	Commercial Services & Supplies
8254	Professional Services
8255	Specialty Retail
8256	Specialty Retail
10962	Textiles, Apparel & Luxury Goods
17863	Building Products
10454	Trading Companies & Distributors
10482	Oil, Gas & Consumable Fuels
17897	Chemicals
8257	Charity/Non-Profit
8258	Professional Services
8259	Capital Markets
10471	Commercial Services & Supplies
9454	Health Care Equipment & Supplies
9454	Health Care Equipment & Supplies
8260	Professional Services
8240	Diversified Consumer Services
8240	Diversified Consumer Services
8241	Health Care Providers & Services
9497	Hotels, Restaurants & Leisure
8261	Professional Services
16617	Capital Markets
8262	Household Durables
8242	Commercial Services & Supplies
9162	Capital Markets
8243	Charity/Non-Profit
8243	Charity/Non-Profit
8244	Diversified Consumer Services
8245	Health Care Equipment & Supplies
10671	Specialty Retail
17068	Specialty Retail
9925	Media
18142	Diversified Consumer Services
8961	Real Estate Management & Development
17613	Charity/Non-Profit
9098	Oil, Gas & Consumable Fuels
8263	Charity/Non-Profit
16735	Beverages
18572	Media
8264	Technology Hardware, Storage & Peripherals
8771	Hotels, Restaurants & Leisure
9986	Commercial Services & Supplies
8265	Charity/Non-Profit
9210	Paper & Forest Products
8266	Professional Services
18493	Specialty Retail
17921	IT Services
8267	Construction & Engineering
8268	Household Durables
17468	Food & Staples Retailing
9491	Hotels, Restaurants & Leisure
17073	Construction & Engineering
10815	Pharmaceuticals
18267	Food Products
17279	Marine
18322	Charity/Non-Profit
18302	Construction & Engineering
10514	Real Estate Management & Development
17074	Media
17110	Diversified Consumer Services
9474	Commercial Services & Supplies
17959	Construction Materials
10328	Energy Equipment & Services
9384	Diversified Financial Services
8269	Construction & Engineering
8270	Charity/Non-Profit
8271	Commercial Services & Supplies
17075	Food Products
17280	Machinery
17280	Machinery
8272	Food & Staples Retailing
8273	Chemicals
8273	Chemicals
8274	Industrial Conglomerates
8275	Trading Companies & Distributors
8275	Trading Companies & Distributors
17469	Electrical Equipment
8276	Auto Components
9620	Banks
10597	Health Care Providers & Services
8277	Media
17587	IT Services
10491	Insurance
9510	Food & Staples Retailing
17958	Food Products
10797	Pharmaceuticals
17761	Leisure Products
9069	Beverages
18218	Food Products
17614	Hotels, Restaurants & Leisure
10619	Specialty Retail
8278	Specialty Retail
8278	Specialty Retail
8279	Electrical Equipment
18295	Distributors
17275	Aerospace & Defense
8280	IT Services
9867	Water Utilities
18168	Public Entities
9635	Air Freight & Logistics
8281	Specialty Retail
10584	Specialty Retail
8282	Machinery
8283	Charity/Non-Profit
8283	Charity/Non-Profit
17399	Paper & Forest Products
10625	Media
8284	Diversified Consumer Services
8285	Textiles, Apparel & Luxury Goods
10533	Professional Services
8286	Professional Services
8287	Automobiles
10066	Internet Software & Services
8288	Hotels, Restaurants & Leisure
9567	Insurance
8289	Marine
8289	Marine
17607	Machinery
8290	Transportation Infrastructure
10593	Insurance
16828	Food Products
17672	Trading Companies & Distributors
8724	IT Services
9556	Software
17400	Food Products
8649	Household Durables
8291	Real Estate Management & Development
17866	Distributors
10197	Air Freight & Logistics
8292	Banks
8293	Electronic Equipment, Instruments & Components
9314	Chemicals
10822	Health Care Providers & Services
17806	Internet Software & Services
8294	Building Products
17281	IT Services
9539	Chemicals
16618	Professional Services
8650	Professional Services
17979	Specialty Retail
9535	Real Estate Management & Development
9727	Pharmaceuticals
9727	Pharmaceuticals
10793	Pharmaceuticals
17292	Professional Services
10759	Diversified Telecommunication Services
17626	Leisure Products
17077	Food Products
8651	Software
8295	Professional Services
8296	Chemicals
8297	Diversified Telecommunication Services
10424	Food Products
8298	Metals & Mining
8298	Metals & Mining
8933	IT Services
8299	Food Products
8652	Commercial Services & Supplies
9623	Distributors
9010	Professional Services
8653	Household Durables
8653	Household Durables
17078	Food Products
8300	Food & Staples Retailing
17987	Construction & Engineering
16674	Construction & Engineering
10604	Professional Services
8301	Commercial Services & Supplies
8861	Specialty Retail
8861	Specialty Retail
10027	Capital Markets
16905	Construction & Engineering
18161	Real Estate Management & Development
8302	Energy Equipment & Services
17763	Software
10313	Charity/Non-Profit
17004	Construction & Engineering
10352	Electronic Equipment, Instruments & Components
8654	IT Services
10530	Communications Equipment
17673	Household Durables
17673	Household Durables
8655	Leisure Products
17289	IT Services
10606	IT Services
9245	Electronic Equipment, Instruments & Components
8656	Textiles, Apparel & Luxury Goods
8656	Textiles, Apparel & Luxury Goods
8303	Diversified Consumer Services
8304	Multi-Utilities
8305	Aerospace & Defense
10773	Wireless Telecommunication Services
8306	IT Services
16943	Commercial Services & Supplies
18335	Health Care Technology
8308	Household Durables
8307	Public Entities
8309	Diversified Telecommunication Services
8309	Diversified Telecommunication Services
17588	Software
8310	Professional Services
9520	Public Entities
10416	IT Services
9495	Professional Services
8311	Chemicals
18088	Specialty Retail
17589	Hotels, Restaurants & Leisure
18126	Trading Companies & Distributors
8717	Machinery
17079	Machinery
10033	Aerospace & Defense
10166	Banks
17282	Diversified Telecommunication Services
8802	Food & Staples Retailing
8312	Diversified Consumer Services
9972	Pharmaceuticals
9246	Semiconductors & Semiconductor Equipment
8313	Hotels, Restaurants & Leisure
10238	Food & Staples Retailing
8314	Food Products
9367	Aerospace & Defense
9625	Real Estate Management & Development
9625	Real Estate Management & Development
8315	Water Utilities
8315	Water Utilities
10227	Beverages
17112	Commercial Services & Supplies
17334	Health Care Equipment & Supplies
17829	Diversified Consumer Services
18371	Media
16815	Diversified Consumer Services
17905	Diversified Financial Services
17430	Construction & Engineering
17962	Auto Components
18075	Diversified Consumer Services
17216	Charity/Non-Profit
17728	Food Products
16737	Health Care Providers & Services
16883	Diversified Financial Services
17035	Media
18402	Hotels, Restaurants & Leisure
9200	Hotels, Restaurants & Leisure
17733	Capital Markets
8319	Specialty Retail
18315	Charity/Non-Profit
17371	Specialty Retail
10529	Machinery
17287	Health Care Providers & Services
17261	Real Estate Management & Development
17258	Health Care Providers & Services
17668	Health Care Providers & Services
8320	Capital Markets
17083	Capital Markets
16733	Consumer Finance
16734	Capital Markets
17305	Real Estate Management & Development
18537	Commercial Services & Supplies
17591	Real Estate Management & Development
8719	Food Products
8321	Construction Materials
8322	Hotels, Restaurants & Leisure
8322	Hotels, Restaurants & Leisure
8657	Insurance
9309	Textiles, Apparel & Luxury Goods
17755	Oil, Gas & Consumable Fuels
9741	Life Sciences Tools & Services
8324	Food Products
8323	Construction & Engineering
17895	Leisure Products
18219	Automobiles
10724	Machinery
17904	Machinery
17814	Metals & Mining
8325	Distributors
10280	Software
16931	Internet & Direct Marketing Retail
8327	Specialty Retail
8658	Hotels, Restaurants & Leisure
10760	Auto Components
18296	Media
18575	Software
9636	Food & Staples Retailing
8328	Construction Materials
10017	Professional Services
8659	Media
16742	Media
17918	Internet Software & Services
8329	Diversified Consumer Services
18533	Trading Companies & Distributors
18089	Real Estate Management & Development
10568	Airlines
16773	Construction & Engineering
8330	Construction & Engineering
8733	Food Products
8331	Professional Services
8332	IT Services
10072	Textiles, Apparel & Luxury Goods
10072	Textiles, Apparel & Luxury Goods
17284	Professional Services
9239	Professional Services
18374	Air Freight & Logistics
18026	Air Freight & Logistics
8660	Real Estate Management & Development
10395	Capital Markets
10300	Insurance
9668	Insurance
17592	Insurance
10446	Construction & Engineering
9443	Air Freight & Logistics
9443	Air Freight & Logistics
18360	Textiles, Apparel & Luxury Goods
17392	Household Durables
17629	Leisure Products
17286	Hotels, Restaurants & Leisure
9516	Construction & Engineering
10499	Specialty Retail
17675	Commercial Services & Supplies
10120	Health Care Providers & Services
8333	Public Entities
18249	Oil, Gas & Consumable Fuels
8334	Machinery
17341	Air Freight & Logistics
18352	Charity/Non-Profit
8661	Industrial Conglomerates
8662	Electrical Equipment
10548	Commercial Services & Supplies
8335	Food & Staples Retailing
8335	Food & Staples Retailing
16678	Oil, Gas & Consumable Fuels
9589	Chemicals
10462	Food & Staples Retailing
8352	IT Services
8352	IT Services
8996	Oil, Gas & Consumable Fuels
8336	Media
8698	Insurance
17764	Capital Markets
9479	Specialty Retail
8337	Consumer Finance
8338	Specialty Retail
9910	Machinery
17783	Automobiles
9643	Specialty Retail
8339	Distributors
9638	Specialty Retail
9108	Capital Markets
9047	Capital Markets
10882	Construction & Engineering
8340	Construction & Engineering
10721	Commercial Services & Supplies
17124	Distributors
17080	Internet Software & Services
10116	Health Care Providers & Services
8341	Real Estate Management & Development
16738	Oil, Gas & Consumable Fuels
9828	Internet & Direct Marketing Retail
10287	Software
18162	Road & Rail
8342	Media
8343	Road & Rail
8343	Road & Rail
10286	Metals & Mining
8817	Insurance
8344	Consumer Finance
17765	IT Services
17864	Internet & Direct Marketing Retail
8345	Professional Services
8994	Trading Companies & Distributors
17372	Software
9600	Beverages
8346	Chemicals
17766	Leisure Products
17766	Leisure Products
18485	Health Care Providers & Services
17474	Diversified Consumer Services
17081	Health Care Providers & Services
10615	Real Estate Management & Development
8347	Building Products
8347	Building Products
17674	Real Estate Management & Development
8348	Electronic Equipment, Instruments & Components
8349	Diversified Consumer Services
8841	Media
8350	Commercial Services & Supplies
18357	Internet & Direct Marketing Retail
10899	Construction & Engineering
8351	Automobiles
16886	Professional Services
18117	Aerospace & Defense
17865	Food Products
17309	Capital Markets
9980	Professional Services
9697	Capital Markets
9697	Capital Markets
8702	Professional Services
10285	Trading Companies & Distributors
17288	Hotels, Restaurants & Leisure
8663	Banks
18048	Food Products
17370	IT Services
17768	Insurance
10782	Electronic Equipment, Instruments & Components
10782	Electronic Equipment, Instruments & Components
17769	Life Sciences Tools & Services
17507	Media
8353	Construction & Engineering
8664	Hotels, Restaurants & Leisure
8665	Food Products
8665	Food Products
17290	Household Durables
10761	Oil, Gas & Consumable Fuels
18006	Health Care Equipment & Supplies
9355	Communications Equipment
9355	Communications Equipment
18156	Trading Companies & Distributors
18045	Road & Rail
8354	Construction & Engineering
17082	Health Care Providers & Services
10008	Road & Rail
8355	Machinery
8356	Professional Services
9674	Air Freight & Logistics
17100	Professional Services
9209	Insurance
9209	Insurance
8357	Professional Services
16882	Distributors
17291	Professional Services
8805	Building Products
17364	Road & Rail
8358	Beverages
17770	Commercial Services & Supplies
17826	Food Products
17644	Real Estate Management & Development
10575	Commercial Services & Supplies
8359	Media
9220	Capital Markets
9221	Capital Markets
9219	Capital Markets
9222	Real Estate Management & Development
8361	Charity/Non-Profit
8360	Media
18238	Food Products
18323	Health Care Providers & Services
8910	Real Estate Management & Development
8363	Thrifts & Mortgage Finance
18240	Distributors
8666	Auto Components
8364	Trading Companies & Distributors
10165	Capital Markets
7505	Capital Markets
17594	Paper & Forest Products
17914	Air Freight & Logistics
8857	Insurance
8365	Electric Utilities
8366	Professional Services
10271	Specialty Retail
8367	IT Services
8367	IT Services
17087	Commercial Services & Supplies
8368	Aerospace & Defense
8692	Building Products
16616	Commercial Services & Supplies
18127	Trading Companies & Distributors
10666	Textiles, Apparel & Luxury Goods
18483	Chemicals
17677	Software
8369	Personal Products
18389	Banks
17504	Air Freight & Logistics
18119	Auto Components
8370	Charity/Non-Profit
9360	Software
16867	Food Products
8372	Health Care Providers & Services
17084	Media
9836	Health Care Providers & Services
17610	Commercial Services & Supplies
9502	Food & Staples Retailing
9502	Food & Staples Retailing
10179	Banks
8371	Water Utilities
8371	Water Utilities
9201	Equity Real Estate Investment Trusts (REITs)
18339	Trading Companies & Distributors
8373	Food Products
8375	Capital Markets
8362	Diversified Consumer Services
10140	Health Care Providers & Services
8376	Health Care Providers & Services
9270	Diversified Consumer Services
8377	Diversified Consumer Services
8377	Diversified Consumer Services
9531	Diversified Consumer Services
9264	Diversified Consumer Services
8378	Diversified Consumer Services
9260	Diversified Consumer Services
8379	Diversified Consumer Services
8815	Diversified Consumer Services
8374	Diversified Consumer Services
18362	Diversified Consumer Services
9293	Diversified Consumer Services
9254	Diversified Consumer Services
9262	Diversified Consumer Services
8380	Diversified Consumer Services
8380	Diversified Consumer Services
8381	Diversified Consumer Services
9259	Diversified Consumer Services
8382	Diversified Consumer Services
8667	Diversified Consumer Services
8667	Diversified Consumer Services
17730	Diversified Consumer Services
17730	Diversified Consumer Services
8383	Diversified Consumer Services
8383	Diversified Consumer Services
9242	Diversified Consumer Services
8384	Diversified Consumer Services
8384	Diversified Consumer Services
10210	Diversified Consumer Services
8385	Diversified Consumer Services
8385	Diversified Consumer Services
9271	Diversified Consumer Services
8386	Diversified Consumer Services
8386	Diversified Consumer Services
8387	Diversified Consumer Services
8388	Diversified Consumer Services
8389	Diversified Consumer Services
8765	Diversified Consumer Services
9263	Diversified Consumer Services
8826	Diversified Consumer Services
9265	Diversified Consumer Services
9257	Diversified Consumer Services
10781	Diversified Consumer Services
9274	Diversified Consumer Services
9278	Diversified Consumer Services
9278	Diversified Consumer Services
8390	Diversified Consumer Services
8391	Diversified Consumer Services
8392	Diversified Consumer Services
8393	Diversified Consumer Services
8393	Diversified Consumer Services
8394	Diversified Consumer Services
8394	Diversified Consumer Services
8395	Diversified Consumer Services
8396	Diversified Consumer Services
8396	Diversified Consumer Services
8397	Diversified Consumer Services
9279	Diversified Consumer Services
9284	Diversified Consumer Services
9284	Diversified Consumer Services
8398	Diversified Consumer Services
8398	Diversified Consumer Services
10230	Diversified Consumer Services
9275	Diversified Consumer Services
9287	Diversified Consumer Services
18567	Diversified Consumer Services
8399	Diversified Consumer Services
9837	Media
8400	Insurance
9484	Distributors
17476	Construction & Engineering
10431	Paper & Forest Products
10870	Real Estate Management & Development
10957	Air Freight & Logistics
10646	Real Estate Management & Development
10872	Real Estate Management & Development
8401	Specialty Retail
8402	Commercial Services & Supplies
8895	Construction & Engineering
17089	Food Products
17786	Commercial Services & Supplies
17926	Insurance
10049	IT Services
8403	Multi-Utilities
8403	Multi-Utilities
9488	Multi-Utilities
16799	Professional Services
8404	Public Entities
17373	Household Durables
17960	Pharmaceuticals
17374	Specialty Retail
10855	Real Estate Management & Development
17262	Food Products
17774	Oil, Gas & Consumable Fuels
10932	Commercial Services & Supplies
10645	Commercial Services & Supplies
8405	Construction & Engineering
8406	Banks
17827	Health Care Equipment & Supplies
10384	Technology Hardware, Storage & Peripherals
10385	Electrical Equipment
10506	Electric Utilities
17402	Diversified Financial Services
18351	Consumer Finance
17772	Consumer Finance
9202	Household Durables
18542	Professional Services
8407	Pharmaceuticals
9599	Metals & Mining
10038	Chemicals
10892	Household Durables
16909	Chemicals
9978	Professional Services
8408	Commercial Services & Supplies
10213	Commercial Services & Supplies
9691	Commercial Services & Supplies
10440	Technology Hardware, Storage & Peripherals
10440	Technology Hardware, Storage & Peripherals
16855	IT Services
18028	Capital Markets
8409	Distributors
8680	Commercial Services & Supplies
10468	Specialty Retail
17828	Electrical Equipment
17828	Electrical Equipment
17090	Food & Staples Retailing
8410	Machinery
8411	Commercial Services & Supplies
10801	Health Care Providers & Services
8691	Textiles, Apparel & Luxury Goods
8412	Construction & Engineering
8681	Media
10152	Health Care Providers & Services
8413	Communications Equipment
9566	Media
8414	Charity/Non-Profit
8814	Charity/Non-Profit
10228	Textiles, Apparel & Luxury Goods
9189	Household Durables
8415	Chemicals
8415	Chemicals
9051	Pharmaceuticals
8416	Construction & Engineering
10512	Construction & Engineering
9165	Hotels, Restaurants & Leisure
9100	Airlines
8417	Health Care Providers & Services
8417	Health Care Providers & Services
9101	Hotels, Restaurants & Leisure
8418	Banks
8418	Banks
10209	Road & Rail
10209	Road & Rail
16712	Independent Power and Renewable Electricity Producers
8419	Charity/Non-Profit
10002	Professional Services
16746	IT Services
8682	IT Services
10626	Internet Software & Services
9979	Specialty Retail
10236	Textiles, Apparel & Luxury Goods
10092	Software
8420	Professional Services
8896	Household Durables
8708	Oil, Gas & Consumable Fuels
10559	Real Estate Management & Development
16944	Leisure Products
9920	Distributors
17375	Internet Software & Services
8421	Health Care Providers & Services
8422	Wireless Telecommunication Services
8422	Wireless Telecommunication Services
17982	Metals & Mining
8423	Metals & Mining
10678	IT Services
9316	Food Products
9411	Electrical Equipment
16830	Construction & Engineering
18366	Construction & Engineering
9700	Construction & Engineering
9097	Automobiles
8683	Consumer Finance
9305	Distributors
18463	Charity/Non-Profit
8424	Building Products
8424	Building Products
9407	Automobiles
10393	Automobiles
10856	Machinery
10720	Specialty Retail
8425	Health Care Providers & Services
10264	Professional Services
8426	Trading Companies & Distributors
17777	Capital Markets
9154	Hotels, Restaurants & Leisure
18525	Commercial Services & Supplies
17342	Health Care Providers & Services
8429	Machinery
17816	Chemicals
17343	Textiles, Apparel & Luxury Goods
10518	Commercial Services & Supplies
8430	Real Estate Management & Development
9637	Gas Utilities
8431	Food & Staples Retailing
8431	Food & Staples Retailing
10832	Construction & Engineering
17778	Household Durables
8432	Professional Services
8432	Professional Services
18030	Food Products
9186	Independent Power and Renewable Electricity Producers
8433	Diversified Consumer Services
8434	Real Estate Management & Development
9117	Media
9117	Media
18479	Household Durables
16903	Construction & Engineering
9728	Real Estate Management & Development
9494	Machinery
9344	Capital Markets
8435	Food Products
8435	Food Products
18007	Specialty Retail
16680	Media
8436	Health Care Providers & Services
9525	Public Entities
18223	Commercial Services & Supplies
8437	Diversified Consumer Services
18010	Hotels, Restaurants & Leisure
10811	Health Care Providers & Services
8438	Commercial Services & Supplies
17294	IT Services
17295	Charity/Non-Profit
16913	Distributors
17296	Machinery
8439	Charity/Non-Profit
8440	Professional Services
17678	Life Sciences Tools & Services
8684	Specialty Retail
9905	Construction & Engineering
8442	Media
16681	Machinery
8443	Distributors
17129	Chemicals
10505	Consumer Finance
16942	Specialty Retail
8444	Food Products
10658	Food Products
17376	Energy Equipment & Services
17479	IT Services
16743	Oil, Gas & Consumable Fuels
9236	Food Products
8445	Professional Services
10091	Diversified Consumer Services
10762	Machinery
10689	Metals & Mining
8446	Commercial Services & Supplies
8446	Commercial Services & Supplies
8447	Hotels, Restaurants & Leisure
8448	Textiles, Apparel & Luxury Goods
17297	Containers & Packaging
16744	Machinery
17596	Trading Companies & Distributors
8449	Food & Staples Retailing
8449	Food & Staples Retailing
8450	Insurance
8450	Insurance
8451	Food Products
18518	Commercial Services & Supplies
8452	Water Utilities
8454	Household Durables
8453	Thrifts & Mortgage Finance
17818	Electronic Equipment, Instruments & Components
9188	Independent Power and Renewable Electricity Producers
9444	Capital Markets
18297	Construction & Engineering
18368	Technology Hardware, Storage & Peripherals
8455	Electric Utilities
18489	Insurance
10406	Insurance
9575	Real Estate Management & Development
17301	Media
9584	Real Estate Management & Development
17204	Chemicals
8456	Household Durables
8457	Food & Staples Retailing
8457	Food & Staples Retailing
8903	Electronic Equipment, Instruments & Components
10082	Health Care Providers & Services
10520	Real Estate Management & Development
9961	Health Care Providers & Services
8965	Diversified Consumer Services
8685	Banks
10813	Health Care Equipment & Supplies
9218	Construction & Engineering
18033	Construction & Engineering
9420	Construction & Engineering
10217	IT Services
8825	IT Services
17630	Construction & Engineering
8458	Professional Services
9194	Commercial Services & Supplies
17298	Household Durables
8459	Real Estate Management & Development
8969	Household Durables
8461	Textiles, Apparel & Luxury Goods
8461	Textiles, Apparel & Luxury Goods
8460	Air Freight & Logistics
8956	Hotels, Restaurants & Leisure
9547	Food Products
9547	Food Products
17597	Professional Services
10846	Commercial Services & Supplies
17299	Electrical Equipment
10783	Food Products
17598	Trading Companies & Distributors
8462	Specialty Retail
8462	Specialty Retail
18444	Food Products
17983	Food & Staples Retailing
17983	Food & Staples Retailing
9403	Specialty Retail
17302	Specialty Retail
9326	Construction Materials
9190	Marine
8463	Construction & Engineering
17303	Professional Services
9035	Food Products
9035	Food Products
16921	Specialty Retail
10274	Construction & Engineering
18516	Capital Markets
8464	Metals & Mining
8465	Hotels, Restaurants & Leisure
18091	Textiles, Apparel & Luxury Goods
18522	Construction & Engineering
18523	Media
18236	Commercial Services & Supplies
9058	Internet & Direct Marketing Retail
10591	IT Services
16710	Textiles, Apparel & Luxury Goods
17315	Commercial Services & Supplies
17315	Commercial Services & Supplies
9506	Construction & Engineering
17378	Construction & Engineering
8824	Construction & Engineering
7278	Professional Services
9870	Professional Services
10871	Commercial Services & Supplies
8466	Air Freight & Logistics
9718	Food Products
8467	Professional Services
17379	Food & Staples Retailing
8468	Food Products
8993	Capital Markets
8469	Construction & Engineering
8469	Construction & Engineering
8470	IT Services
8470	IT Services
17094	Wireless Telecommunication Services
9253	Diversified Consumer Services
8472	Diversified Consumer Services
8471	Professional Services
8894	Professional Services
8473	Professional Services
8881	Construction & Engineering
8427	Media
8428	Chemicals
8474	Household Durables
9617	Air Freight & Logistics
8709	Commercial Services & Supplies
16683	Commercial Services & Supplies
8475	Pharmaceuticals
17304	Metals & Mining
8476	Trading Companies & Distributors
8476	Trading Companies & Distributors
8477	Charity/Non-Profit
10218	Professional Services
10704	Distributors
8686	Capital Markets
17095	Road & Rail
9843	Specialty Retail
10132	Health Care Providers & Services
18121	Professional Services
8478	Equity Real Estate Investment Trusts (REITs)
17781	Diversified Financial Services
18559	Oil, Gas & Consumable Fuels
10585	Commercial Services & Supplies
17127	Professional Services
8957	IT Services
8786	Hotels, Restaurants & Leisure
9348	Hotels, Restaurants & Leisure
17782	Charity/Non-Profit
8687	Distributors
16800	Energy Equipment & Services
9075	Media
9773	Containers & Packaging
9703	Food & Staples Retailing
9289	Diversified Consumer Services
17306	Health Care Providers & Services
17096	Food Products
16685	Capital Markets
8480	Professional Services
10510	Hotels, Restaurants & Leisure
8481	Construction & Engineering
8481	Construction & Engineering
17505	Construction & Engineering
9558	Electronic Equipment, Instruments & Components
8482	Distributors
8479	Diversified Financial Services
17680	Distributors
9522	Public Entities
8483	Construction & Engineering
10479	Food Products
9089	Hotels, Restaurants & Leisure
8484	Food Products
8484	Food Products
16858	Technology Hardware, Storage & Peripherals
8485	Insurance
8485	Insurance
10507	Technology Hardware, Storage & Peripherals
9530	Technology Hardware, Storage & Peripherals
8486	Semiconductors & Semiconductor Equipment
16832	Insurance
10715	Insurance
18441	Electronic Equipment, Instruments & Components
18441	Electronic Equipment, Instruments & Components
8487	Energy Equipment & Services
8488	Energy Equipment & Services
16782	Air Freight & Logistics
17681	Auto Components
10481	Building Products
18031	Banks
18326	Internet Software & Services
16801	Auto Components
10057	Specialty Retail
8489	Machinery
9404	Chemicals
10046	Electronic Equipment, Instruments & Components
17480	Industrial Conglomerates
8490	Auto Components
9838	Commercial Services & Supplies
18471	Media
9552	Food Products
8491	Specialty Retail
8823	Charity/Non-Profit
8493	Air Freight & Logistics
8723	Internet & Direct Marketing Retail
10137	Air Freight & Logistics
8688	Thrifts & Mortgage Finance
8495	Charity/Non-Profit
8496	Water Utilities
8676	Diversified Consumer Services
8676	Diversified Consumer Services
8494	Health Care Providers & Services
10032	Commercial Services & Supplies
8997	Hotels, Restaurants & Leisure
8497	Media
9985	Hotels, Restaurants & Leisure
8498	Food Products
8492	Real Estate Management & Development
8492	Real Estate Management & Development
8499	Real Estate Management & Development
8499	Real Estate Management & Development
18324	Textiles, Apparel & Luxury Goods
8500	Professional Services
9241	Multiline Retail
8689	Internet & Direct Marketing Retail
18325	Diversified Telecommunication Services
17097	Hotels, Restaurants & Leisure
17380	Trading Companies & Distributors
8502	Commercial Services & Supplies
17098	Household Products
10589	Commercial Services & Supplies
9470	Specialty Retail
10906	Media
10035	Aerospace & Defense
8503	Pharmaceuticals
18298	Electronic Equipment, Instruments & Components
17600	Internet Software & Services
8907	Chemicals
8690	Internet Software & Services
8504	Professional Services
8892	Electrical Equipment
8905	Insurance}
  end
end
