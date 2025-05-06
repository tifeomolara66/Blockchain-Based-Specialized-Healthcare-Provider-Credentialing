;; Education Verification Contract
;; Validates medical training and educational credentials

;; Error codes
(define-constant ERR_UNAUTHORIZED (err u100))
(define-constant ERR_ALREADY_EXISTS (err u101))
(define-constant ERR_NOT_FOUND (err u102))

;; Data structures
(define-map education-credentials
  { provider-id: principal, credential-id: uint }
  {
    institution: (string-utf8 100),
    degree: (string-utf8 100),
    field: (string-utf8 100),
    year-completed: uint,
    verified: bool,
    verifier: (optional principal)
  }
)

;; Track credential count per provider
(define-map provider-credential-count
  { provider-id: principal }
  { count: uint }
)

;; Track contract administrator and authorized verifiers
(define-data-var contract-owner principal tx-sender)
(define-map authorized-verifiers principal bool)

;; Check if caller is contract owner
(define-private (is-contract-owner)
  (is-eq tx-sender (var-get contract-owner))
)

;; Check if caller is authorized verifier
(define-private (is-authorized-verifier)
  (default-to false (map-get? authorized-verifiers tx-sender))
)

;; Get next credential ID for a provider
(define-private (get-next-credential-id (provider-id principal))
  (let ((current-count (default-to { count: u0 } (map-get? provider-credential-count { provider-id: provider-id }))))
    (begin
      (map-set provider-credential-count
              { provider-id: provider-id }
              { count: (+ u1 (get count current-count)) })
      (get count current-count)
    )
  )
)

;; Add education credential
(define-public (add-education-credential
                (institution (string-utf8 100))
                (degree (string-utf8 100))
                (field (string-utf8 100))
                (year-completed uint))
  (let ((next-id (get-next-credential-id tx-sender)))
    (ok (map-set education-credentials
                { provider-id: tx-sender, credential-id: next-id }
                {
                  institution: institution,
                  degree: degree,
                  field: field,
                  year-completed: year-completed,
                  verified: false,
                  verifier: none
                }))
  )
)

;; Verify education credential
(define-public (verify-credential (provider-id principal) (credential-id uint))
  (let ((credential (map-get? education-credentials { provider-id: provider-id, credential-id: credential-id })))
    (begin
      (asserts! (or (is-contract-owner) (is-authorized-verifier)) ERR_UNAUTHORIZED)
      (asserts! (is-some credential) ERR_NOT_FOUND)
      (ok (map-set education-credentials
                  { provider-id: provider-id, credential-id: credential-id }
                  (merge (unwrap-panic credential)
                        {
                          verified: true,
                          verifier: (some tx-sender)
                        })))
    )
  )
)

;; Get education credential
(define-read-only (get-education-credential (provider-id principal) (credential-id uint))
  (map-get? education-credentials { provider-id: provider-id, credential-id: credential-id })
)

;; Get credential count for a provider
(define-read-only (get-credential-count (provider-id principal))
  (default-to { count: u0 } (map-get? provider-credential-count { provider-id: provider-id }))
)

;; Add authorized verifier
(define-public (add-authorized-verifier (verifier principal))
  (begin
    (asserts! (is-contract-owner) ERR_UNAUTHORIZED)
    (ok (map-set authorized-verifiers verifier true))
  )
)

;; Remove authorized verifier
(define-public (remove-authorized-verifier (verifier principal))
  (begin
    (asserts! (is-contract-owner) ERR_UNAUTHORIZED)
    (ok (map-delete authorized-verifiers verifier))
  )
)

;; Transfer contract ownership
(define-public (transfer-ownership (new-owner principal))
  (begin
    (asserts! (is-contract-owner) ERR_UNAUTHORIZED)
    (var-set contract-owner new-owner)
    (ok true)
  )
)
