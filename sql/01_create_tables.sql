-- Create main socioeconomic data table
CREATE TABLE IF NOT EXISTS socio_data (
    "ID" INTEGER,
    "Sex" TEXT,
    "Marital status" TEXT,
    "Age" INTEGER,
    "Education" TEXT,
    "Income" INTEGER,
    "Occupation" TEXT,
    "Settlement size" INTEGER
);

-- Create indices for better query performance
CREATE INDEX IF NOT EXISTS idx_socio_education ON socio_data("Education");
CREATE INDEX IF NOT EXISTS idx_socio_income ON socio_data("Income");
CREATE INDEX IF NOT EXISTS idx_socio_occupation ON socio_data("Occupation");
CREATE INDEX IF NOT EXISTS idx_socio_sex ON socio_data("Sex");

-- Optional: Create a view for common analysis
CREATE OR REPLACE VIEW income_by_demographic AS
SELECT 
    "Sex",
    "Education",
    "Occupation",
    "Settlement size",
    AVG("Income") AS avg_income,
    COUNT(*) AS count
FROM socio_data
GROUP BY "Sex", "Education", "Occupation", "Settlement size";

-- Add comments to the table for documentation
COMMENT ON TABLE socio_data IS 'Socioeconomic factors and income dataset from Kaggle';
COMMENT ON COLUMN socio_data."Sex" IS '0 = Female, 1 = Male (text encoding)';
COMMENT ON COLUMN socio_data."Income" IS 'Income level (numeric encoding)';
COMMENT ON COLUMN socio_data."Settlement size" IS 'Size category of residence area (numeric encoding)';
