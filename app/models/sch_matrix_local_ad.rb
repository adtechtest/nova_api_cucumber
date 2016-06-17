class SchMatrixLocalAd < AmagiReportsDb
  self.table_name = "SCH_MATRIX_LOCAL_ADS"
  self.primary_key = "ID"

  belongs_to :sch_matrix_break, :foreign_key => "SCH_MATRIX_BRK_ID"
end
