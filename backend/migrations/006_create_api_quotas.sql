-- Migration: 006_create_api_quotas
-- Description: Create api_quotas table for tracking monthly API usage
-- Applied: 2026-02-12

CREATE TABLE IF NOT EXISTS api_quotas (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    provider_name VARCHAR(50) NOT NULL,
    month_year VARCHAR(7) NOT NULL, -- Format: YYYY-MM
    request_count INTEGER NOT NULL DEFAULT 0,
    max_allowed INTEGER NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(provider_name, month_year)
);

CREATE INDEX idx_api_quotas_provider_month ON api_quotas(provider_name, month_year);

CREATE TRIGGER api_quotas_updated_at
    BEFORE UPDATE ON api_quotas
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at();

ALTER TABLE api_quotas ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Service role has full access to api_quotas"
    ON api_quotas FOR ALL
    USING (auth.role() = 'service_role');

COMMENT ON TABLE api_quotas IS 'Tracks monthly API request counts per provider for quota management';
