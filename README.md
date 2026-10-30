# Caritas Youth Jobs Portal — Version 1.2

This version upgrades the local prototype to a Supabase-backed architecture with a secure admin sign-in and database Row Level Security policies.

**Start here:** read `SETUP-V1.2.md` from top to bottom. You must create/configure your Supabase project, paste its URL and anon/public key into `config.js`, run `supabase-schema.sql`, create an authorized administrator, and deploy the files before it can work online.

No demo jobs are imported. Only records whose status is `published` appear on the public website. The initial schema allows Rawalpindi and Islamabad only.

Never place a Supabase service-role/secret key in browser code. Do not disable Row Level Security.
