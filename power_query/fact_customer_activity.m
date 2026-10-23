let
    Source = row_data,
    #"Removed Columns" = Table.RemoveColumns(Source,{"Year_Birth", "Education", "Marital_Status", "Income", "Kidhome", "Teenhome", "Z_CostContact", "Z_Revenue"}),
    #"Renamed Columns" = Table.RenameColumns(#"Removed Columns",{{"ID", "customer_id"}}),
    #"Added Custom" = Table.AddColumn(#"Renamed Columns", "total_spend", each [MntWines]+[MntFruits]+[MntMeatProducts]+[MntFishProducts]+[MntSweetProducts]+[MntGoldProds]),
    #"Reordered Columns" = Table.ReorderColumns(#"Added Custom",{"customer_id", "Dt_Customer", "Recency", "MntWines", "MntFruits", "MntMeatProducts", "MntFishProducts", "MntSweetProducts", "MntGoldProds", "total_spend", "NumDealsPurchases", "NumWebPurchases", "NumCatalogPurchases", "NumStorePurchases", "NumWebVisitsMonth", "AcceptedCmp3", "AcceptedCmp4", "AcceptedCmp5", "AcceptedCmp1", "AcceptedCmp2", "Complain", "Response"}),
    #"Added Custom1" = Table.AddColumn(#"Reordered Columns", "total_purchases", each [NumDealsPurchases]+[NumWebPurchases]+[NumCatalogPurchases]+[NumStorePurchases]),
    #"Reordered Columns1" = Table.ReorderColumns(#"Added Custom1",{"customer_id", "Dt_Customer", "Recency", "MntWines", "MntFruits", "MntMeatProducts", "MntFishProducts", "MntSweetProducts", "MntGoldProds", "total_spend", "NumDealsPurchases", "NumWebPurchases", "NumCatalogPurchases", "NumStorePurchases", "total_purchases", "NumWebVisitsMonth", "Response", "AcceptedCmp1", "AcceptedCmp2", "AcceptedCmp3", "AcceptedCmp4", "AcceptedCmp5", "Complain"}),
    #"Changed Type with Locale" = Table.TransformColumnTypes(#"Reordered Columns1", {{"Dt_Customer", type date}}, "en-GB"),
    #"Changed Type" = Table.TransformColumnTypes(#"Changed Type with Locale",{{"total_spend", Int64.Type}, {"total_purchases", Int64.Type}}),
    #"Renamed Columns1" = Table.RenameColumns(#"Changed Type",{{"Dt_Customer", "Date"}})
in
    #"Renamed Columns1"
