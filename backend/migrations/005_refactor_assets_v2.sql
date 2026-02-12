-- Migration: 005_refactor_assets_v2
-- Description: Refactor assets table to use flexible JSONB architecture
-- Applied: 2026-02-12

-- Step 1: Add new enum values (custom, liability)
ALTER TYPE asset_type ADD VALUE IF NOT EXISTS 'custom';
ALTER TYPE asset_type ADD VALUE IF NOT EXISTS 'liability';

-- Step 2: Add core_data and extended_data JSONB columns
ALTER TABLE assets ADD COLUMN IF NOT EXISTS core_data JSONB DEFAULT '{}';
ALTER TABLE assets ADD COLUMN IF NOT EXISTS extended_data JSONB DEFAULT '{}';

-- Step 3: Migrate existing data into core_data
UPDATE assets SET core_data = jsonb_build_object(
    'name', name,
    'quantity', quantity,
    'purchase_price', purchase_price,
    'currency', currency
) || CASE WHEN symbol IS NOT NULL THEN jsonb_build_object('symbol', symbol) ELSE '{}'::jsonb END
  || CASE WHEN current_price IS NOT NULL THEN jsonb_build_object('current_price', current_price) ELSE '{}'::jsonb END
  || CASE WHEN purchase_date IS NOT NULL THEN jsonb_build_object('purchase_date', purchase_date::text) ELSE '{}'::jsonb END
  || CASE WHEN notes IS NOT NULL THEN jsonb_build_object('notes', notes) ELSE '{}'::jsonb END
  || COALESCE(metadata, '{}'::jsonb)
WHERE core_data = '{}' OR core_data IS NULL;

-- Step 4: Drop old rigid columns
ALTER TABLE assets DROP COLUMN IF EXISTS symbol;
ALTER TABLE assets DROP COLUMN IF EXISTS quantity;
ALTER TABLE assets DROP COLUMN IF EXISTS purchase_price;
ALTER TABLE assets DROP COLUMN IF EXISTS current_price;
ALTER TABLE assets DROP COLUMN IF EXISTS currency;
ALTER TABLE assets DROP COLUMN IF EXISTS purchase_date;
ALTER TABLE assets DROP COLUMN IF EXISTS notes;
ALTER TABLE assets DROP COLUMN IF EXISTS metadata;

-- Step 5: Create GIN indexes on JSONB columns
CREATE INDEX IF NOT EXISTS idx_assets_core_data ON assets USING GIN (core_data);
CREATE INDEX IF NOT EXISTS idx_assets_extended_data ON assets USING GIN (extended_data);

-- Step 6: Update comments
COMMENT ON COLUMN assets.core_data IS 'Manual fields submitted by the user. Schema varies by asset_type';
COMMENT ON COLUMN assets.extended_data IS 'Auto-filled fields from market data APIs';
