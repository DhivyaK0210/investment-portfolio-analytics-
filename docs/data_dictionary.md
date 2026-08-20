# Data Dictionary

## Countries
`CountryID` — Primary key  
`CountryName` — Standardised country name  
`Region` — Geographic region

## Investors
`InvestorID` — Primary key  
`FirstName`, `LastName` — Investor name  
`Email`, `PhoneNumber` — Contact information  
`CountryID` — Foreign key to Countries  
`DateJoined` — Investor onboarding date  
`RiskProfile` — Low / Medium / High  
`InvestorType` — Individual / Corporate / Institutional  
`Status` — Active / Inactive

## Funds
`FundID` — Primary key  
`FundName` — Fund name  
`FundType` — Fund classification  
`RiskLevel` — Low / Medium / High  
`BaseCurrency` — Reporting currency  
`LaunchDate` — Fund launch date  
`FundManager` — Fund manager  
`Status` — Fund status  
`Benchmark` — Comparison benchmark

## Assets
`AssetID` — Primary key  
`AssetName` — Asset/security name  
`AssetType` — Equity / ETF / Bond ETF / Commodity ETF  
`Sector` — Sector  
`Country` — Listing/issuer country  
`Market` — Trading venue  
`Currency` — Trading currency  
`Ticker` — Ticker

## InvestorTransactions
`TransactionID` — Primary key  
`InvestorID` — Foreign key to Investors  
`FundID` — Foreign key to Funds  
`TransactionDate` — Transaction date  
`TransactionType` — Subscription / Redemption  
`Amount` — Signed transaction amount  
`Currency` — Transaction currency

## FundTrades
`TradeID` — Primary key  
`FundID` — Foreign key to Funds  
`AssetID` — Foreign key to Assets  
`TradeDate` — Trade date  
`TradeType` — Buy / Sell  
`Quantity` — Units traded  
`TradePrice` — Price per unit  
`GrossValue` — Quantity × trade price

## FundNAV
`FundID` — Foreign key to Funds  
`NAVDate` — NAV observation date  
`NAVPerUnit` — Net asset value per fund unit  
`AUM` — Assets under management  
`MonthlyReturn` — Synthetic monthly return  
`BenchmarkReturn` — Synthetic benchmark return  
Composite primary key: `FundID + NAVDate`
