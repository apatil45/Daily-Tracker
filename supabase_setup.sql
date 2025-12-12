-- Bootcamp Tracker - Supabase Setup SQL
-- Run this in your Supabase SQL Editor

-- Create completed_days table
CREATE TABLE IF NOT EXISTS completed_days (
    id BIGSERIAL PRIMARY KEY,
    day_index INTEGER NOT NULL,
    user_id TEXT NOT NULL,
    completed_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(day_index, user_id)
);

-- Create completed_tasks table
CREATE TABLE IF NOT EXISTS completed_tasks (
    id BIGSERIAL PRIMARY KEY,
    day_index INTEGER NOT NULL,
    task_index INTEGER NOT NULL,
    user_id TEXT NOT NULL,
    completed_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(day_index, task_index, user_id)
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_completed_days_user ON completed_days(user_id);
CREATE INDEX IF NOT EXISTS idx_completed_days_day ON completed_days(day_index);
CREATE INDEX IF NOT EXISTS idx_completed_tasks_user ON completed_tasks(user_id);
CREATE INDEX IF NOT EXISTS idx_completed_tasks_day ON completed_tasks(day_index);

-- Disable RLS for now (enable later if needed for security)
ALTER TABLE completed_days DISABLE ROW LEVEL SECURITY;
ALTER TABLE completed_tasks DISABLE ROW LEVEL SECURITY;

-- Create updated_at trigger function
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create triggers
DROP TRIGGER IF EXISTS update_completed_days_updated_at ON completed_days;
CREATE TRIGGER update_completed_days_updated_at BEFORE UPDATE ON completed_days
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_completed_tasks_updated_at ON completed_tasks;
CREATE TRIGGER update_completed_tasks_updated_at BEFORE UPDATE ON completed_tasks
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

