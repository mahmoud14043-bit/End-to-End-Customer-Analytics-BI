let
    Source = Csv.Document(File.Contents("C:\Users\caliv\Downloads\archive (1)\marketing_campaign.csv"),[Delimiter="	", Columns=29, Encoding=1252, QuoteStyle=QuoteStyle.None]),
    #"Promoted Headers" = Table.PromoteHeaders(Source, [PromoteAllScalars=true]),
    #"Changed Type" = Table.TransformColumnTypes(#"Promoted Headers",{{"ID", Int64.Type}, {"Year_Birth", Int64.Type}, {"Education", type text}, {"Marital_Status", type text}, {"Income", Int64.Type}, {"Kidhome", Int64.Type}, {"Teenhome", Int64.Type}, {"Dt_Customer", type text}, {"Recency", Int64.Type}, {"MntWines", Int64.Type}, {"MntFruits", Int64.Type}, {"MntMeatProducts", Int64.Type}, {"MntFishProducts", Int64.Type}, {"MntSweetProducts", Int64.Type}, {"MntGoldProds", Int64.Type}, {"NumDealsPurchases", Int64.Type}, {"NumWebPurchases", Int64.Type}, {"NumCatalogPurchases", Int64.Type}, {"NumStorePurchases", Int64.Type}, {"NumWebVisitsMonth", Int64.Type}, {"AcceptedCmp3", Int64.Type}, {"AcceptedCmp4", Int64.Type}, {"AcceptedCmp5", Int64.Type}, {"AcceptedCmp1", Int64.Type}, {"AcceptedCmp2", Int64.Type}, {"Complain", Int64.Type}, {"Z_CostContact", Int64.Type}, {"Z_Revenue", Int64.Type}, {"Response", Int64.Type}}),
    #"Removed Other Columns" = Table.SelectColumns(#"Changed Type",{"ID", "Year_Birth", "Education", "Marital_Status", "Income", "Kidhome", "Teenhome", "Dt_Customer"}),
    #"Renamed Columns" = Table.RenameColumns(#"Removed Other Columns",{{"ID", "customer_id"}}),
    #"Changed Type with Locale" = Table.TransformColumnTypes(#"Renamed Columns", {{"Dt_Customer", type date}}, "en-GB"),
    #"Added Custom" = Table.AddColumn(#"Changed Type with Locale", "age", each 2026 - [Year_Birth]),
    #"Reordered Columns" = Table.ReorderColumns(#"Added Custom",{"customer_id", "Year_Birth", "age", "Education", "Marital_Status", "Income", "Kidhome", "Teenhome", "Dt_Customer"}),
    #"Added Custom1" = Table.AddColumn(#"Reordered Columns", "total_children", each [Kidhome] +[Teenhome]),
    #"Changed Type1" = Table.TransformColumnTypes(#"Added Custom1",{{"age", Int64.Type}, {"total_children", Int64.Type}})
in
    #"Changed Type1"
