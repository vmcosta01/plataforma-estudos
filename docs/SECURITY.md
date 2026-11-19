# SECURITY — Requisitos de segurança (camada zero)

> Versão 0.1 · 18/11/2026 · Conceitos #12 e #13. Documento de planejamento: vale antes da primeira linha de código.

## 1. Papéis e permissões (multiusuário, enforced no servidor)

| Papel | Pode | Não pode |
| --- | --- | --- |
| `aluno` | Ler e editar só a própria matrícula, plano, sessões, respostas, simulados, preferências e dispositivos; ler concursos, disciplinas, tópicos e questões `publicada` | Ver dados de outros alunos; ver questões em rascunho; alterar edital |
| `revisor` | Tudo do aluno + criar/editar/revisar questões e marcar `publicada` ou `suspensa` | Alterar edital, pesos e fórmula; ver dados pessoais de alunos |
| `admin` | Gerir concursos, edital, flags, papéis; ver métricas agregadas | Ler conteúdo das conversas de alunos sem motivo registrado |

Regras: Row Level Security em todas as tabelas com dados de usuário; regras de negócio em Edge Functions com verificação de papel; nunca confiar em papel enviado pelo app.

## 2. Segredos e configuração

- Segredos só em variáveis de ambiente, separadas por estágio (local, preview, produção); modelo em `.env.example`.
- `.env` fora do git (`.gitignore`); chave `service_role` do Supabase nunca no app ou no site.
- Chave da API do modelo só nas Edge Functions.
- Rotação de chaves se houver suspeita de vazamento; registro em `DECISIONS.md`.

## 3. Entrada e saída

- Validação de todo input no servidor (schema, tamanhos, tipos).
- Limite de requisições por usuário nas rotas de IA (evita abuso e custo).
- Texto do aluno enviado ao modelo é tratado como dado: o prompt do tutor não executa instruções vindas da mensagem do aluno que mudem regras do sistema.
- Saída do modelo exibida como texto; nada é executado.

## 4. Dados pessoais (LGPD)

| Dado | Finalidade | Base | Retenção |
| --- | --- | --- | --- |
| Nome, e-mail | Conta e contato | Execução do serviço | Enquanto a conta existir |
| Polo, horários, horas | Plano de estudos | Execução do serviço | Enquanto a conta existir |
| Respostas, sessões, notas | Plano e progresso | Execução do serviço | Enquanto a conta existir; agregados anônimos depois |
| Token de push | Notificações | Consentimento | Até revogar ou sair |
| Nota real (questionário pós-prova) | Medir precisão | Consentimento | 12 meses, depois anonimizada |

- Consentimento explícito para notificações e para o questionário de nota real.
- Exclusão de conta apaga dados pessoais em até 15 dias (botão em T12).
- Política de privacidade e termos publicados antes do piloto.
- Dados no Brasil ou em região com cláusulas adequadas (verificar região do Supabase).
- Conversas com o tutor: não usadas para treinar modelos de terceiros (checar termos do provedor da API).

## 5. Infraestrutura

- HTTPS em tudo; HSTS no site.
- Backups diários do banco, com teste de restauração mensal.
- Logs sem dados sensíveis (sem senha, token ou conteúdo integral de conversas).
- Dependências verificadas no CI (auditoria de pacotes).

## 6. Checklist antes de produção

- [ ] RLS ativa e testada em todas as tabelas de usuário
- [ ] Nenhum segredo no repositório (varredura no CI)
- [ ] Limites de requisição nas rotas de IA
- [ ] Política de privacidade e termos publicados
- [ ] Exclusão de conta funcionando
- [ ] Backup e restauração testados
