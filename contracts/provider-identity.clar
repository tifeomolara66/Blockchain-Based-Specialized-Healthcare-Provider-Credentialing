;; Provider Identity Contract
;; Manages healthcare practitioner profiles

;; Error codes
(define-constant ERR_UNAUTHORIZED (err u100))
(define-constant ERR_ALREADY_REGISTERED (err u101))
(define-constant ERR_NOT_FOUND (err u102))

;; Data structures
(define-map providers
  { provider-id: principal }
  {
    name: (string-utf8 100),
    specialty: (string-utf8 100),
    contact-info: (string-utf8 200),
    active: bool,
    registration-date: uint
  }
)

;; Track contract administrator
(define-data-var contract-owner principal tx-sender)

;; Check if caller is contract owner
(define-private (is-contract-owner)
  (is-eq tx-sender (var-get contract-owner))
)

;; Register a new healthcare provider
(define-public (register-provider
                (name (string-utf8 100))
                (specialty (string-utf8 100))
                (contact-info (string-utf8 200)))
  (let ((provider-exists (map-get? providers {provider-id: tx-sender})))
    (asserts! (is-none provider-exists) ERR_ALREADY_REGISTERED)
    (ok (map-set providers
                {provider-id: tx-sender}
                {
                  name: name,
                  specialty: specialty,
                  contact-info: contact-info,
                  active: true,
                  registration-date: block-height
                }))
  )
)

;; Update provider information
(define-public (update-provider
                (name (string-utf8 100))
                (specialty (string-utf8 100))
                (contact-info (string-utf8 200)))
  (let ((provider-data (map-get? providers {provider-id: tx-sender})))
    (asserts! (is-some provider-data) ERR_NOT_FOUND)
    (ok (map-set providers
                {provider-id: tx-sender}
                (merge (unwrap-panic provider-data)
                      {
                        name: name,
                        specialty: specialty,
                        contact-info: contact-info
                      })))
  )
)

;; Deactivate a provider
(define-public (deactivate-provider (provider-id principal))
  (let ((provider-data (map-get? providers {provider-id: provider-id})))
    (asserts! (or (is-contract-owner) (is-eq tx-sender provider-id)) ERR_UNAUTHORIZED)
    (asserts! (is-some provider-data) ERR_NOT_FOUND)
    (ok (map-set providers
                {provider-id: provider-id}
                (merge (unwrap-panic provider-data)
                      {active: false})))
  )
)

;; Reactivate a provider
(define-public (reactivate-provider (provider-id principal))
  (let ((provider-data (map-get? providers {provider-id: provider-id})))
    (asserts! (is-contract-owner) ERR_UNAUTHORIZED)
    (asserts! (is-some provider-data) ERR_NOT_FOUND)
    (ok (map-set providers
                {provider-id: provider-id}
                (merge (unwrap-panic provider-data)
                      {active: true})))
  )
)

;; Get provider information
(define-read-only (get-provider (provider-id principal))
  (map-get? providers {provider-id: provider-id})
)

;; Transfer contract ownership
(define-public (transfer-ownership (new-owner principal))
  (begin
    (asserts! (is-contract-owner) ERR_UNAUTHORIZED)
    (var-set contract-owner new-owner)
    (ok true)
  )
)
