# DECISIONS — Registro de decisões (ADRs)

> Conceito #7. Formato: data, decisão, motivo, alternativas, status. Status **proposta** = aguarda aprovação do dono.

## ADR-0 · 18/11/2026 · Piloto com o Banestes Técnico Bancário
- **Decisão:** o primeiro concurso do produto é o Banestes 01/2026, Técnico Bancário (FCC, prova em 24/01/2027).
- **Motivo:** edital publicado e fechado, prova próxima com resultado mensurável, público local (ES).
- **Alternativas:** concursos federais 2027 (datas incertas); carreiras jurídicas (sem edital publicado).
- **Status:** aprovada pelo dono (conversa de 18/11/2026).

## ADR-1 · 18/11/2026 · TypeScript em monorepo: Expo (app), Next.js (site), Tauri (desktop)
- **Decisão:** um monorepo pnpm/Turborepo; Expo para Android e iPhone; Next.js para o site/PWA; Tauri sobre o site no pós-piloto.
- **Motivo:** uma linguagem e tipos compartilhados; push nativo no Expo; menor prazo para o piloto.
- **Alternativas:** Flutter (outra linguagem, sem reaproveitar o site); apps nativos separados (prazo inviável).
- **Status:** proposta.

## ADR-2 · 18/11/2026 · Supabase como backend e Vercel para o site
- **Decisão:** Postgres + Auth + RLS + Edge Functions + pg_cron no Supabase; site na Vercel; build do app pelo EAS.
- **Motivo:** multiusuário com regras no banco; cron nativo para avisos; estágios preview/produção; conectores já disponíveis na conta do dono.
- **Alternativas:** Firebase (regras menos expressivas para o domínio relacional); backend próprio (mais tempo).
- **Status:** proposta.

## ADR-3 · 18/11/2026 · Modelo maior via API para tutor e questões no piloto
- **Decisão:** usar modelo de API para sessão guiada e geração de questões; provedor escolhido por benchmark (`EVALUATION.md`).
- **Motivo:** qualidade em português e precisão no conteúdo são críticas; modelos pequenos erram mais gabarito.
- **Status:** proposta; provedor em aberto.

## ADR-4 · 18/11/2026 · Agente local em CPU só depois do piloto
- **Decisão:** o agente de editais (modelo de 3–4B em CPU via llama.cpp) fica fora do piloto.
- **Motivo:** o piloto tem um único edital, já carregado manualmente; prazo curto.
- **Status:** proposta.

## ADR-6 · 19/11/2026 · Iniciar a Fase 1 com a stack proposta
- **Decisão:** o dono ordenou continuar até criar todos os arquivos iniciais (18/11/2026, 23:01). A Fase 1 começou com a stack dos ADR-1 e ADR-2, adotada de forma provisória.
- **Motivo:** prazo do piloto; a fundação (núcleo, banco, RLS, seed, CI) vale para qualquer front-end.
- **Reversibilidade:** alta. Nada de Expo, Next.js ou Supabase em nuvem foi criado; o núcleo é TypeScript puro e o SQL é Postgres padrão.
- **Pendente:** aprovação formal do PRD e dos ADR-1 a ADR-3 pelo dono.
- **Status:** aprovada (ordem do dono), stack provisória.

## ADR-7 · 19/11/2026 · Fonte única do edital em packages/core; seed gerado
- **Decisão:** o edital vive em `packages/core/src/editais/`; `supabase/seed.sql` é gerado por script e o CI falha se divergir.
- **Motivo:** evitar duas verdades sobre pesos, questões e tópicos.
- **Status:** aprovada (SPEC 1.6).

## ADR-8 · 19/11/2026 · Arredondamento da nota (item 14.2 do edital)
- **Decisão:** arredondar cada prova para duas casas (meia para cima) e depois a média ponderada, também para duas casas; habilitado se a média arredondada ≥ 6,00.
- **Motivo:** o item 14.2 diz que "todos os cálculos" são feitos com duas casas. Para o Banestes (30 e 40 questões) as notas possíveis são múltiplos de 1/18, então a ordem do arredondamento nunca muda quem é habilitado.
- **Status:** aprovada.

## ADR-9 · 19/11/2026 · Projeto Supabase e endurecimento de segurança
- **Decisão:** projeto `plataforma-estudos` (ref `syaijialseosppxhgfqp`), plano gratuito, região sa-east-1 (São Paulo), criado com autorização do dono. Funções de RLS movidas para o schema `privado` (fora da API), `search_path` fixo, uma política por ação e índices em todas as chaves estrangeiras (migração 3), atendendo o Security/Performance Advisor.
- **Status:** migrações 1, 2 e 3 e seed aplicados (migração 3 autorizada pelo dono em 18/11/2026, 23:56); Security Advisor sem alertas; RLS testada na nuvem.

## ADR-10 · 19/11/2026 · Login com e-mail e Google
- **Decisão:** e-mail com confirmação e Google OAuth (SPEC 1.5). Login com Apple a avaliar antes de publicar no iPhone.
- **Status:** aprovada pelo dono.

## ADR-5 · 18/11/2026 · Conteúdo próprio; apostila só como referência interna
- **Decisão:** explicações e questões são geradas e revisadas; nada da apostila ou de cursos é reproduzido no app.
- **Motivo:** direitos autorais e diferenciação.
- **Status:** proposta (cuidado registrado na conversa de 18/11/2026; falta aprovação formal).

## ADR-11 · 19/11/2026 · Questões de provas anteriores
- **Decisão:**
  - Reprodução literal, sem alterar a questão, sempre com a origem: banca, ano, órgão e cargo. Isso reforça o caráter informativo e de estudo.
  - Canal de retirada: se alguma banca notificar, a questão sai do ar rápido.
  - Separação no banco: questões reais de provas anteriores ficam separadas das questões inéditas geradas pela nossa IA, para dar para retirar umas sem afetar as outras.
- **Status:** aprovada pelo dono.
