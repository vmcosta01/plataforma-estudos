# src/agents — Agentes de IA

| Agente | Fase | Arquivo previsto |
| --- | --- | --- |
| Tutor da sessão guiada | 3 | `tutor/prompt.md`, `tutor/contexto.ts` |
| Gerador de questões estilo FCC | 3 | `gerador-questoes/prompt.md` |
| Revisor automático de gabarito (modelo ≠ gerador) | 3 | `revisor/prompt.md` |
| Agente de editais (CPU, llama.cpp) | pós-piloto | `editais/` |

Regras: prompts versionados; nenhum agente vai para produção sem benchmark em `docs/EVALUATION.md`; texto do aluno é dado, nunca instrução de sistema (`docs/SECURITY.md` §3).
