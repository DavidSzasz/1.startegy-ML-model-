DO $$
DECLARE
    t text;
BEGIN
    FOR t IN 
        SELECT table_name 
        FROM information_schema.columns 
        WHERE table_schema = 'public' 
          AND column_name = 'updated_at'
    LOOP
        EXECUTE format('
            DROP TRIGGER IF EXISTS trg_set_updated_at ON %I;
            CREATE TRIGGER trg_set_updated_at
            BEFORE UPDATE ON %I
            FOR EACH ROW
            EXECUTE FUNCTION set_updated_at();', t, t);
    END LOOP;
END $$;