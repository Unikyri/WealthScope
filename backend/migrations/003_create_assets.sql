-- Migration: 003_create_assets
-- Description: Create assets table for managing user investments
-- Applied: 2026-01-27

-- Create asset type enum
CREATE TYPE asset_type AS ENUM (
    'stock',
    'etf',
    'bond',
    'crypto',
    'real_estate',
    'gold',
    'cash',
    'other'
);

-- Create assets table
CREATE TABLE IF NOT EXISTS assets (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    type asset_type NOT NULL,
    name VARCHAR(255) NOT NULL,
    symbol VARCHAR(20),
    quantity DECIMAL(20, 8) NOT NULL CHECK (quantity > 0),
    purchase_price DECIMAL(20, 2) NOT NULL CHECK (purchase_price >= 0),
    current_price DECIMAL(20, 2),
    currency VARCHAR(3) NOT NULL DEFAULT 'USD',
    purchase_date DATE,
    metadata JSONB DEFAULT '{}',
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Indexes for common queries
CREATE INDEX idx_assets_user_id ON assets(user_id);
CREATE INDEX idx_assets_type ON assets(type);
CREATE INDEX idx_assets_symbol ON assets(symbol) WHERE symbol IS NOT NULL;
CREATE INDEX idx_assets_created_at ON assets(created_at DESC);

-- Trigger to auto-update updated_at
CREATE TRIGGER assets_updated_at
    BEFORE UPDATE ON assets
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at();

-- Enable Row Level Security
ALTER TABLE assets ENABLE ROW LEVEL SECURITY;

-- RLS Policies for assets
-- Users can only see their own assets
CREATE POLICY "Users can view own assets"
    ON assets FOR SELECT
    USING (user_id = auth.uid());

CREATE POLICY "Users can create own assets"
    ON assets FOR INSERT
    WITH CHECK (user_id = auth.uid());

CREATE POLICY "Users can update own assets"
    ON assets FOR UPDATE
    USING (user_id = auth.uid());

CREATE POLICY "Users can delete own assets"
    ON assets FOR DELETE
    USING (user_id = auth.uid());

-- Service role bypass for backend operations
CREATE POLICY "Service role has full access"
    ON assets FOR ALL
    USING (auth.role() = 'service_role');

-- Add comment for documentation
COMMENT ON TABLE assets IS 'User investment assets including stocks, bonds, real estate, crypto, etc.';
COMMENT ON COLUMN assets.metadata IS 'Type-specific data stored as JSON. E.g., real estate has address, size; bonds have maturity_date, coupon_rate';
