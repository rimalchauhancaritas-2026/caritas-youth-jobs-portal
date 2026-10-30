# Caritas Youth Jobs Portal — Version 1.2 setup

This version is a **database-connected starter package**. It becomes live only after you create/configure your own Supabase project and publish the files to a host. The ZIP itself does not create accounts or host a public website.

## What is included
- `index.html`: public jobs page; shows only database listings with status `published`.
- `job.html`: live job details loaded by ID.
- `admin.html`: email/password sign-in and job create/edit/delete panel.
- `admin.js`: admin operations using Supabase Auth; there is no public sign-up page.
- `config.js`: project URL and anon/public key placeholders.
- `supabase-schema.sql`: database schema and row-level security (RLS) policies.

## A. Create the online database
1. Open https://supabase.com/ and create/sign in to an account. Create a new project and keep the database password private.
2. In your project, open **SQL Editor** → **New query**.
3. Open `supabase-schema.sql` from this folder, copy all its contents into the SQL Editor and run it.
4. Open **Project Settings → API** (the exact menu labels may vary). Copy the **Project URL** and the **anon/public key**.
5. Edit `config.js` in a plain-text editor. Replace the two placeholder values with your Project URL and anon/public key. Save it.
   - The anon/public key is designed for browser use with the RLS policies in the SQL file.
   - **Never put a `service_role`, secret, database password, or other privileged key in `config.js` or any public website file.**

## B. Create the first administrator safely
1. In Supabase, open **Authentication → Users** and add/invite the administrator email. Set a strong unique password or use the invite flow.
2. Copy that user's UUID from the user list.
3. In **SQL Editor**, run this command after replacing the example UUID with the exact UUID from your project:

```sql
insert into public.admin_profiles (user_id)
values ('PASTE-THE-AUTH-USER-UUID-HERE');
```

4. Do not create any public sign-up flow. Only add trusted staff UUIDs to `admin_profiles`. The browser cannot grant itself administrator rights.

## C. Publish the website
1. Upload the folder's website files to a static host such as GitHub Pages (public repository for GitHub Free) or Cloudflare Pages.
2. Keep `index.html`, `job.html`, `admin.html`, `styles.css`, `app.js`, `admin.js`, and `config.js` together in the deployed site root.
3. Open the public site and test the job list. The homepage will be empty until an administrator creates a listing and changes its status to **Published**.
4. Visit `/admin.html`, sign in with the authorized account, create a test listing in Draft, then change it to Published and verify it appears on the public homepage.
5. In Supabase Authentication settings, configure the site's allowed URL / redirect URL to your actual deployed domain before relying on production authentication.

## D. Before public launch
- Delete/avoid demo jobs; this version does not import the old local demo data.
- Verify every job, source, application link and deadline.
- Test admin login, unauthorized login, public published-job viewing, and draft visibility.
- Use HTTPS and a strong unique admin password; enable MFA for admin accounts if available.
- Confirm permission to use official Caritas branding and any newspaper advertisement images.
- Add backups and a process for archiving expired jobs.

## Important limitations
- This is a first database-connected version, not a website that has already been deployed or connected to your Supabase account.
- A browser-based static site cannot hide its anon/public key; security depends on the supplied Row Level Security policies and correct project configuration. Do not disable RLS.
- The public site only reads `published` jobs. Drafts and archived jobs are hidden from public visitors.
- The schema restricts locations to Rawalpindi and Islamabad, matching the initial launch plan.
- If you change the SQL schema or RLS rules, test them before publishing.
