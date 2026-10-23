let
    Source = row_data,
    #"Removed Other Columns" = Table.SelectColumns(Source,{"Dt_Customer"}),
    #"Changed Type with Locale" = Table.TransformColumnTypes(#"Removed Other Columns", {{"Dt_Customer", type date}}, "en-GB"),
    #"Removed Duplicates" = Table.Distinct(#"Changed Type with Locale"),
    #"Inserted Year" = Table.AddColumn(#"Removed Duplicates", "Year", each Date.Year([Dt_Customer]), Int64.Type),
    #"Inserted Month" = Table.AddColumn(#"Inserted Year", "Month", each Date.Month([Dt_Customer]), Int64.Type),
    #"Inserted Month Name" = Table.AddColumn(#"Inserted Month", "Month Name", each Date.MonthName([Dt_Customer]), type text),
    #"Inserted Quarter" = Table.AddColumn(#"Inserted Month Name", "Quarter", each Date.QuarterOfYear([Dt_Customer]), Int64.Type),
    #"Renamed Columns" = Table.RenameColumns(#"Inserted Quarter",{{"Dt_Customer", "Date"}})
in
    #"Renamed Columns"
