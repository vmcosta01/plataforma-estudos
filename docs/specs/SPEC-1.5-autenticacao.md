# SPEC 1.5 — Autenticação (e-mail e Google)

- **Fase:** 1 · **Conceitos:** #5, #12, #13 · **Status:** aprovada (dono escolheu e-mail + Google em 19/11/2026)

## Contexto
T1 do `APP_FLOW.md`. O Supabase Auth já está ativo no projeto `plataforma-estudos` (ref `syaijialseosppxhgfqp`, região São Paulo). O trigger `ao_criar_usuario` cria o `perfil` com papel `aluno`.

## Tarefa
1. Login com **e-mail e senha** (com confirmação por e-mail) e com **Google (OAuth)**.
2. Telas de cadastro, entrada, "esqueci a senha" no app e no site (Fase 2, junto da T1).
3. Aceite de termos e política de privacidade registrado no cadastro.

## Configuração no painel do Supabase (Authentication)
| Item | Valor |
| --- | --- |
| Email provider | Ativo; "Confirm email" ligado; senha mínima 8 caracteres |
| Site URL | URL do site em produção (definir na Fase 6); em desenvolvimento, `http://localhost:3000` |
| Redirect URLs | `http://localhost:3000/**`, URL de preview da Vercel, esquema do app (`plataformaestudos://**`) |
| Google provider | Ativo, com Client ID e Client Secret do Google Cloud (abaixo) |
| Templates de e-mail | Em português (confirmação, recuperação de senha) |

## Passo a passo do Google (feito pelo dono, conta Google dele)
1. Abrir https://console.cloud.google.com/ → criar projeto "plataforma-estudos".
2. "APIs e serviços" → "Tela de consentimento OAuth" → tipo **Externo**; nome do app, e-mail de suporte, domínio (quando houver).
3. "Credenciais" → "Criar credenciais" → "ID do cliente OAuth" → tipo **Aplicativo da Web**.
4. Em "URIs de redirecionamento autorizados", colar: `https://syaijialseosppxhgfqp.supabase.co/auth/v1/callback`.
5. Copiar Client ID e Client Secret para Supabase → Authentication → Providers → Google. **Não colar o segredo em nenhum arquivo do projeto.**
6. Para o app (Fase 2): criar também IDs de cliente Android e iOS e usar login nativo com `signInWithIdToken`.

## Constraints
- Segredos só no painel do Supabase ou em `.env` (nunca no repositório).
- Papel sempre `aluno` no cadastro; mudança de papel só por admin (painel / service_role).
- Sessão persistida no app com armazenamento seguro (SecureStore).

## Critérios de aceitação
1. Cadastro por e-mail cria `auth.users` + `perfil` (papel `aluno`) — verificado por SQL.
2. Login com Google cria o mesmo perfil.
3. Usuário não confirmado não acessa dados (RLS exige usuário autenticado).
4. "Esqueci a senha" envia e-mail e permite redefinir.
5. Testes de RLS continuam verdes.

## Out of scope
Login com Apple (exigido pela App Store se houver login social no iPhone — **avaliar antes da publicação no iOS**), login por telefone, SSO corporativo.
