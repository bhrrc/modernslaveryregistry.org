class AddDefaultIndustries < ActiveRecord::Migration[5.0]
  def up
    [
      {
        "sector_name": "Energy",
        "sector_code": 10,
        "industry_group_name": "Energy",
        "industry_group_code": 1010,
        "industry_name": "Energy Equipment & Services",
        "industry_code": 101010
      },
      {
        "sector_name": "Energy",
        "sector_code": 10,
        "industry_group_name": "Energy",
        "industry_group_code": 1010,
        "industry_name": "Oil, Gas & Consumable Fuels",
        "industry_code": 101020
      },
      {
        "sector_name": "Materials",
        "sector_code": 15,
        "industry_group_name": "Materials",
        "industry_group_code": 1510,
        "industry_name": "Oil, Gas & Consumable Fuels",
        "industry_code": 101020
      },
      {
        "sector_name": "Materials",
        "sector_code": 15,
        "industry_group_name": "Materials",
        "industry_group_code": 1510,
        "industry_name": "Chemicals",
        "industry_code": 151010
      },
      {
        "sector_name": "Materials",
        "sector_code": 15,
        "industry_group_name": "Materials",
        "industry_group_code": 1510,
        "industry_name": "Construction Materials",
        "industry_code": 151020
      },
      {
        "sector_name": "Materials",
        "sector_code": 15,
        "industry_group_name": "Materials",
        "industry_group_code": 1510,
        "industry_name": "Containers & Packaging",
        "industry_code": 151030
      },
      {
        "sector_name": "Materials",
        "sector_code": 15,
        "industry_group_name": "Materials",
        "industry_group_code": 1510,
        "industry_name": "Metals & Mining",
        "industry_code": 151040
      },
      {
        "sector_name": "Materials",
        "sector_code": 15,
        "industry_group_name": "Materials",
        "industry_group_code": 1510,
        "industry_name": "Paper & Forest Products",
        "industry_code": 151050
      },
      {
        "sector_name": "Industrials",
        "sector_code": 20,
        "industry_group_name": "Capital Goods",
        "industry_group_code": 2010,
        "industry_name": "Aerospace & Defense",
        "industry_code": 201010
      },
      {
        "sector_name": "Industrials",
        "sector_code": 20,
        "industry_group_name": "Capital Goods",
        "industry_group_code": 2010,
        "industry_name": "Building Products",
        "industry_code": 201020
      },
      {
        "sector_name": "Industrials",
        "sector_code": 20,
        "industry_group_name": "Capital Goods",
        "industry_group_code": 2010,
        "industry_name": "Construction & Engineering",
        "industry_code": 201030
      },
      {
        "sector_name": "Industrials",
        "sector_code": 20,
        "industry_group_name": "Capital Goods",
        "industry_group_code": 2010,
        "industry_name": "Electrical Equipment",
        "industry_code": 201040
      },
      {
        "sector_name": "Industrials",
        "sector_code": 20,
        "industry_group_name": "Capital Goods",
        "industry_group_code": 2010,
        "industry_name": "Industrial Conglomerates",
        "industry_code": 201050
      },
      {
        "sector_name": "Industrials",
        "sector_code": 20,
        "industry_group_name": "Capital Goods",
        "industry_group_code": 2010,
        "industry_name": "Machinery",
        "industry_code": 201060
      },
      {
        "sector_name": "Industrials",
        "sector_code": 20,
        "industry_group_name": "Capital Goods",
        "industry_group_code": 2010,
        "industry_name": "Trading Companies & Distributors",
        "industry_code": 201070
      },
      {
        "sector_name": "Industrials",
        "sector_code": 20,
        "industry_group_name": "Commercial & Professional Services",
        "industry_group_code": 2020,
        "industry_name": "Commercial Services & Supplies",
        "industry_code": 202010
      },
      {
        "sector_name": "Industrials",
        "sector_code": 20,
        "industry_group_name": "Commercial & Professional Services",
        "industry_group_code": 2020,
        "industry_name": "Professional Services",
        "industry_code": 202020
      },
      {
        "sector_name": "Industrials",
        "sector_code": 20,
        "industry_group_name": "Transportation",
        "industry_group_code": 2030,
        "industry_name": "Air Freight & Logistics",
        "industry_code": 203010
      },
      {
        "sector_name": "Industrials",
        "sector_code": 20,
        "industry_group_name": "Transportation",
        "industry_group_code": 2030,
        "industry_name": "Airlines",
        "industry_code": 203020
      },
      {
        "sector_name": "Industrials",
        "sector_code": 20,
        "industry_group_name": "Transportation",
        "industry_group_code": 2030,
        "industry_name": "Marine",
        "industry_code": 203030
      },
      {
        "sector_name": "Industrials",
        "sector_code": 20,
        "industry_group_name": "Transportation",
        "industry_group_code": 2030,
        "industry_name": "Road & Rail",
        "industry_code": 203040
      },
      {
        "sector_name": "Industrials",
        "sector_code": 20,
        "industry_group_name": "Transportation",
        "industry_group_code": 2030,
        "industry_name": "Transportation Infrastructure",
        "industry_code": 203050
      },
      {
        "sector_name": "Consumer Discretionary",
        "sector_code": 25,
        "industry_group_name": "Automobiles & Components",
        "industry_group_code": 2510,
        "industry_name": "Auto Components",
        "industry_code": 251010
      },
      {
        "sector_name": "Consumer Discretionary",
        "sector_code": 25,
        "industry_group_name": "Automobiles & Components",
        "industry_group_code": 2510,
        "industry_name": "Automobiles",
        "industry_code": 251020
      },
      {
        "sector_name": "Consumer Discretionary",
        "sector_code": 25,
        "industry_group_name": "Consumer Durables & Apparel",
        "industry_group_code": 2520,
        "industry_name": "Household Durables",
        "industry_code": 252010
      },
      {
        "sector_name": "Consumer Discretionary",
        "sector_code": 25,
        "industry_group_name": "Consumer Durables & Apparel",
        "industry_group_code": 2520,
        "industry_name": "Leisure Products",
        "industry_code": 252020
      },
      {
        "sector_name": "Consumer Discretionary",
        "sector_code": 25,
        "industry_group_name": "Consumer Durables & Apparel",
        "industry_group_code": 2520,
        "industry_name": "Textiles, Apparel & Luxury Goods",
        "industry_code": 252030
      },
      {
        "sector_name": "Consumer Discretionary",
        "sector_code": 25,
        "industry_group_name": "Consumer Services",
        "industry_group_code": 2530,
        "industry_name": "Hotels, Restaurants & Leisure",
        "industry_code": 253010
      },
      {
        "sector_name": "Consumer Discretionary",
        "sector_code": 25,
        "industry_group_name": "Consumer Services",
        "industry_group_code": 2530,
        "industry_name": "Diversified Consumer Services",
        "industry_code": 253020
      },
      {
        "sector_name": "Consumer Discretionary",
        "sector_code": 25,
        "industry_group_name": "Media",
        "industry_group_code": 2540,
        "industry_name": "Media",
        "industry_code": 254010
      },
      {
        "sector_name": "Consumer Discretionary",
        "sector_code": 25,
        "industry_group_name": "Retailing",
        "industry_group_code": 2550,
        "industry_name": "Distributors",
        "industry_code": 255010
      },
      {
        "sector_name": "Consumer Discretionary",
        "sector_code": 25,
        "industry_group_name": "Retailing",
        "industry_group_code": 2550,
        "industry_name": "Internet & Direct Marketing Retail",
        "industry_code": 255020
      },
      {
        "sector_name": "Consumer Discretionary",
        "sector_code": 25,
        "industry_group_name": "Retailing",
        "industry_group_code": 2550,
        "industry_name": "Multiline Retail",
        "industry_code": 255030
      },
      {
        "sector_name": "Consumer Discretionary",
        "sector_code": 25,
        "industry_group_name": "Retailing",
        "industry_group_code": 2550,
        "industry_name": "Specialty Retail",
        "industry_code": 255040
      },
      {
        "sector_name": "Consumer Staples",
        "sector_code": 30,
        "industry_group_name": "Food & Staples Retailing",
        "industry_group_code": 3010,
        "industry_name": "Food & Staples Retailing",
        "industry_code": 301010
      },
      {
        "sector_name": "Consumer Staples",
        "sector_code": 30,
        "industry_group_name": "Food, Beverage & Tobacco",
        "industry_group_code": 3020,
        "industry_name": "Beverages",
        "industry_code": 302010
      },
      {
        "sector_name": "Consumer Staples",
        "sector_code": 30,
        "industry_group_name": "Food, Beverage & Tobacco",
        "industry_group_code": 3020,
        "industry_name": "Food Products",
        "industry_code": 302020
      },
      {
        "sector_name": "Consumer Staples",
        "sector_code": 30,
        "industry_group_name": "Food, Beverage & Tobacco",
        "industry_group_code": 3020,
        "industry_name": "Tobacco",
        "industry_code": 302030
      },
      {
        "sector_name": "Consumer Staples",
        "sector_code": 30,
        "industry_group_name": "Household & Personal Products",
        "industry_group_code": 3030,
        "industry_name": "Household Products",
        "industry_code": 303010
      },
      {
        "sector_name": "Consumer Staples",
        "sector_code": 30,
        "industry_group_name": "Household & Personal Products",
        "industry_group_code": 3030,
        "industry_name": "Personal Products",
        "industry_code": 303020
      },
      {
        "sector_name": "Health Care",
        "sector_code": 35,
        "industry_group_name": "Health Care Equipment & Services",
        "industry_group_code": 3510,
        "industry_name": "Health Care Equipment & Supplies",
        "industry_code": 351010
      },
      {
        "sector_name": "Health Care",
        "sector_code": 35,
        "industry_group_name": "Health Care Equipment & Services",
        "industry_group_code": 3510,
        "industry_name": "Health Care Providers & Services",
        "industry_code": 351020
      },
      {
        "sector_name": "Health Care",
        "sector_code": 35,
        "industry_group_name": "Health Care Equipment & Services",
        "industry_group_code": 3510,
        "industry_name": "Health Care Technology",
        "industry_code": 351030
      },
      {
        "sector_name": "Health Care",
        "sector_code": 35,
        "industry_group_name": "Pharmaceuticals, Biotechnology & Life Sciences",
        "industry_group_code": 3520,
        "industry_name": "Biotechnology",
        "industry_code": 352010
      },
      {
        "sector_name": "Health Care",
        "sector_code": 35,
        "industry_group_name": "Pharmaceuticals, Biotechnology & Life Sciences",
        "industry_group_code": 3520,
        "industry_name": "Pharmaceuticals",
        "industry_code": 352020
      },
      {
        "sector_name": "Health Care",
        "sector_code": 35,
        "industry_group_name": "Pharmaceuticals, Biotechnology & Life Sciences",
        "industry_group_code": 3520,
        "industry_name": "Life Sciences Tools & Services",
        "industry_code": 352030
      },
      {
        "sector_name": "Financials",
        "sector_code": 40,
        "industry_group_name": "Banks",
        "industry_group_code": 4010,
        "industry_name": "Banks",
        "industry_code": 401010
      },
      {
        "sector_name": "Financials",
        "sector_code": 40,
        "industry_group_name": "Banks",
        "industry_group_code": 4010,
        "industry_name": "Thrifts & Mortgage Finance",
        "industry_code": 401020
      },
      {
        "sector_name": "Financials",
        "sector_code": 40,
        "industry_group_name": "Diversified Financials",
        "industry_group_code": 4020,
        "industry_name": "Diversified Financial Services",
        "industry_code": 402010
      },
      {
        "sector_name": "Financials",
        "sector_code": 40,
        "industry_group_name": "Diversified Financials",
        "industry_group_code": 4020,
        "industry_name": "Consumer Finance",
        "industry_code": 402020
      },
      {
        "sector_name": "Financials",
        "sector_code": 40,
        "industry_group_name": "Diversified Financials",
        "industry_group_code": 4020,
        "industry_name": "Capital Markets",
        "industry_code": 402030
      },
      {
        "sector_name": "Financials",
        "sector_code": 40,
        "industry_group_name": "Diversified Financials",
        "industry_group_code": 4020,
        "industry_name": "Mortgage Real Estate Investment Trusts (REITs)",
        "industry_code": 402040
      },
      {
        "sector_name": "Financials",
        "sector_code": 40,
        "industry_group_name": "Insurance",
        "industry_group_code": 4030,
        "industry_name": "Insurance",
        "industry_code": 403010
      },
      {
        "sector_name": "Information Technology",
        "sector_code": 45,
        "industry_group_name": "Software & Services",
        "industry_group_code": 4510,
        "industry_name": "Internet Software & Services",
        "industry_code": 451010
      },
      {
        "sector_name": "Information Technology",
        "sector_code": 45,
        "industry_group_name": "Software & Services",
        "industry_group_code": 4510,
        "industry_name": "IT Services",
        "industry_code": 451020
      },
      {
        "sector_name": "Information Technology",
        "sector_code": 45,
        "industry_group_name": "Software & Services",
        "industry_group_code": 4510,
        "industry_name": "Software",
        "industry_code": 451030
      },
      {
        "sector_name": "Information Technology",
        "sector_code": 45,
        "industry_group_name": "Technology Hardware & Equipment",
        "industry_group_code": 4520,
        "industry_name": "Communications Equipment",
        "industry_code": 452010
      },
      {
        "sector_name": "Information Technology",
        "sector_code": 45,
        "industry_group_name": "Technology Hardware & Equipment",
        "industry_group_code": 4520,
        "industry_name": "Technology Hardware, Storage & Peripherals",
        "industry_code": 452020
      },
      {
        "sector_name": "Information Technology",
        "sector_code": 45,
        "industry_group_name": "Technology Hardware & Equipment",
        "industry_group_code": 4520,
        "industry_name": "Electronic Equipment, Instruments & Components",
        "industry_code": 452030
      },
      {
        "sector_name": "Information Technology",
        "sector_code": 45,
        "industry_group_name": "Semiconductors & Semiconductor Equipment",
        "industry_group_code": 4530,
        "industry_name": "Semiconductors & Semiconductor Equipment",
        "industry_code": 453010
      },
      {
        "sector_name": "Telecommunication Services",
        "sector_code": 50,
        "industry_group_name": "Telecommunication Services",
        "industry_group_code": 5010,
        "industry_name": "Diversified Telecommunication Services",
        "industry_code": 501010
      },
      {
        "sector_name": "Telecommunication Services",
        "sector_code": 50,
        "industry_group_name": "Telecommunication Services",
        "industry_group_code": 5010,
        "industry_name": "Wireless Telecommunication Services",
        "industry_code": 501020
      },
      {
        "sector_name": "Utilities",
        "sector_code": 55,
        "industry_group_name": "Utilities",
        "industry_group_code": 5510,
        "industry_name": "Electric Utilities",
        "industry_code": 551010
      },
      {
        "sector_name": "Utilities",
        "sector_code": 55,
        "industry_group_name": "Utilities",
        "industry_group_code": 5510,
        "industry_name": "Gas Utilities",
        "industry_code": 551020
      },
      {
        "sector_name": "Utilities",
        "sector_code": 55,
        "industry_group_name": "Utilities",
        "industry_group_code": 5510,
        "industry_name": "Multi-Utilities",
        "industry_code": 551030
      },
      {
        "sector_name": "Utilities",
        "sector_code": 55,
        "industry_group_name": "Utilities",
        "industry_group_code": 5510,
        "industry_name": "Water Utilities",
        "industry_code": 551040
      },
      {
        "sector_name": "Utilities",
        "sector_code": 55,
        "industry_group_name": "Utilities",
        "industry_group_code": 5510,
        "industry_name": "Independent Power and Renewable Electricity Producers",
        "industry_code": 551050
      },
      {
        "sector_name": "Real Estate",
        "sector_code": 60,
        "industry_group_name": "Real Estate",
        "industry_group_code": 6010,
        "industry_name": "Equity Real Estate Investment Trusts (REITs)",
        "industry_code": 601010
      },
      {
        "sector_name": "Real Estate",
        "sector_code": 60,
        "industry_group_name": "Real Estate",
        "industry_group_code": 6010,
        "industry_name": "Real Estate Management & Development",
        "industry_code": 601020
      }
    ].each do |row|
      Industry.create!(row)
    end
  end
end

# https://en.wikipedia.org/wiki/Global_Industry_Classification_Standard

# JSON.stringify([].slice.apply(document.querySelectorAll('.wikitable tbody tr'), [1]).map(tr => [].slice.apply(tr.querySelectorAll('td')).map(td => td.innerText)).reduce((standards, cols) => {
#    const stringifiedLastStandard = JSON.stringify(standards[standards.length - 1] || {})
#    const standard = JSON.parse(stringifiedLastStandard)
#    for (var i = 0; i < cols.length; i += 2) {
#      if (cols[i].length == 2) { standard.sector_name = cols[i + 1]; standard.sector_code = Number(cols[i]) }
#      if (cols[i].length == 4) { standard.industry_group_name = cols[i + 1]; standard.industry_group_code = Number(cols[i]) }
#      if (cols[i].length == 6) { standard.industry_name = cols[i + 1]; standard.industry_code = Number(cols[i]) }
#    }
#    const stringifiedStandard = JSON.stringify(standard)
#    return stringifiedStandard == stringifiedLastStandard ? standards : standards.concat(standard)
# }, []), null, 2)
