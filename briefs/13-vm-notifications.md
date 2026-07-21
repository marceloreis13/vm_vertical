# Propose 13 — vm_notifications (Push + Locais)

## Objetivo

Módulo unificado de notificações push e locais, desacoplado do provedor (FCM, APNs,
local notifications), com API única e configuração injetada.

## Escopo / Responsabilidades

- **Push**: registro de token, recepção em foreground/background, tap→deep link.
- **Locais**: agendamento, canais/categorias, permissões.
- Roteamento do payload da notificação para navegação (integra vm_navigation).
- Provider plugável (FCM, etc.) e provider fake para dev.

## Injeção / Configuração

App injeta o provider push, chaves e handlers de payload→rota. Módulos podem agendar
notificações locais pela interface.

## Standalone (`example/`)

App exemplo que agenda notificação local e simula um push (provider fake) abrindo uma rota.

## Dependências

- Base (Propose 1). Integra: vm_navigation (deep link), vm_config (gate). Pode usar
  vm_permissions quando existir.

## Testes

- Unit tests de agendamento e roteamento de payload com provider fake.

## Critérios de sucesso

- Trocar provedor push não afeta call sites.
- Tap na notificação leva à rota correta.

## Fora de escopo

- Backend de envio de push.
