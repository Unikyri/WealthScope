-- Migration: 002_users_rls
-- Description: Enable Row Level Security on users table
-- Applied: 2026-01-27

-- Enable Row Level Security on users table
ALTER TABLE users ENABLE ROW LEVEL SECURITY;

-- Policy: Users can only read their own data
CREATE POLICY users_select_own ON users
    FOR SELECT
    USING (auth.uid() = id);

-- Policy: Users can only update their own data
CREATE POLICY users_update_own ON users
    FOR UPDATE
    USING (auth.uid() = id);

-- Policy: Insert allowed for authenticated users (their own record)
CREATE POLICY users_insert_own ON users
    FOR INSERT
    WITH CHECK (auth.uid() = id);

-- Policy: Users can only delete their own data
CREATE POLICY users_delete_own ON users
    FOR DELETE
    USING (auth.uid() = id);
