-- Migration: 008_create_messages
-- Description: Create messages table for AI chat conversation messages
-- Applied: 2026-02-13

CREATE TABLE IF NOT EXISTS messages (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    conversation_id UUID NOT NULL REFERENCES conversations(id) ON DELETE CASCADE,
    role VARCHAR(20) NOT NULL,
    content TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);

-- Indexes
CREATE INDEX idx_messages_conversation_id ON messages(conversation_id);
CREATE INDEX idx_messages_created_at ON messages(created_at ASC);

-- Enable Row Level Security
ALTER TABLE messages ENABLE ROW LEVEL SECURITY;

-- RLS Policies (messages inherit access from their conversation)
CREATE POLICY "Users can view messages of own conversations"
    ON messages FOR SELECT
    USING (conversation_id IN (
        SELECT id FROM conversations WHERE user_id = auth.uid()
    ));

CREATE POLICY "Users can create messages in own conversations"
    ON messages FOR INSERT
    WITH CHECK (conversation_id IN (
        SELECT id FROM conversations WHERE user_id = auth.uid()
    ));

CREATE POLICY "Users can delete messages of own conversations"
    ON messages FOR DELETE
    USING (conversation_id IN (
        SELECT id FROM conversations WHERE user_id = auth.uid()
    ));

-- Service role bypass for backend operations
CREATE POLICY "Service role has full access to messages"
    ON messages FOR ALL
    USING (auth.role() = 'service_role');

COMMENT ON TABLE messages IS 'Messages within AI chat conversations (role: user or assistant)';
