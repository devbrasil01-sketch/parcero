-- ============================================================
--  PARCERO — Migration 001
--  Tabela: beta_signups
--  Propósito: capturar inscrições da landing page (lista de espera beta fundador)
--
--  Como aplicar:
--  1. Acesse seu projeto em https://supabase.com/dashboard
--  2. Vá em "SQL Editor" → "New query"
--  3. Cole todo o conteúdo deste arquivo e clique em "Run"
--  4. Confirme que a tabela aparece em "Table Editor"
-- ============================================================

-- ─────────────────────────────────────────────
-- Extensão UUID (já habilitada por padrão no Supabase)
-- ─────────────────────────────────────────────
create extension if not exists "uuid-ossp";


-- ─────────────────────────────────────────────
-- Tabela principal
-- ─────────────────────────────────────────────
create table if not exists beta_signups (
  id                  uuid          primary key default uuid_generate_v4(),

  -- Campos obrigatórios
  nome                text          not null check (char_length(trim(nome)) >= 2),
  email               text          not null check (email ~* '^[^@]+@[^@]+\.[^@]+$'),
  whatsapp            text          not null check (char_length(regexp_replace(whatsapp, '\D', '', 'g')) between 10 and 13),
  creci               text          not null check (char_length(trim(creci)) >= 1),
  cidade              text          not null check (char_length(trim(cidade)) >= 2),
  estado              char(2)       not null check (estado in (
                        'AC','AL','AP','AM','BA','CE','DF','ES','GO',
                        'MA','MT','MS','MG','PA','PB','PR','PE','PI',
                        'RJ','RN','RS','RO','RR','SC','SP','SE','TO'
                      )),
  perfil_atuacao      text          not null check (perfil_atuacao in (
                        'corretor_autonomo', 'imobiliaria', 'gestor_comercial', 'outro'
                      )),

  -- Campos opcionais (pesquisa de produto)
  como_faz_parcerias  text          check (como_faz_parcerias is null or como_faz_parcerias in (
                        'grupos_whatsapp', 'indicacao_direta', 'planilha_crm', 'poucas_parcerias', 'outro'
                      )),
  como_conheceu       text          check (como_conheceu is null or como_conheceu in (
                        'grupo_whatsapp', 'indicacao_corretor', 'instagram', 'google', 'outro'
                      )),

  -- Auditoria e conformidade LGPD
  privacy_accepted_at timestamptz   not null,
  source              text          not null default 'landing_page',
  created_at          timestamptz   not null default now(),

  constraint beta_signups_email_unique unique (email)
);

create index if not exists idx_beta_signups_created_at on beta_signups(created_at desc);
create index if not exists idx_beta_signups_estado     on beta_signups(estado);
create index if not exists idx_beta_signups_perfil     on beta_signups(perfil_atuacao);

comment on table  beta_signups                     is 'Lista de espera do beta fundador capturada pela landing page';
comment on column beta_signups.privacy_accepted_at is 'Timestamp exato do aceite da Política de Privacidade pelo usuário';
comment on column beta_signups.source              is 'Origem do cadastro (padrão: landing_page)';


-- ─────────────────────────────────────────────
-- Row Level Security (RLS)
-- ─────────────────────────────────────────────
alter table beta_signups enable row level security;

-- ✅ Visitantes anônimos podem INSERIR (enviar o formulário)
create policy "anon_can_insert_beta_signup"
  on beta_signups
  for insert
  to anon
  with check (true);

-- 🚫 Sem policy de SELECT/UPDATE/DELETE = RLS bloqueia automaticamente
-- Para ler os dados, use a service_role key no Supabase Studio ou back-end.

-- ✅ Migration 001 concluída.
