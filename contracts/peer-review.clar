;; Peer Review Contract
;; Manages quality assessment by colleagues

;; Error codes
(define-constant ERR_UNAUTHORIZED (err u100))
(define-constant ERR_ALREADY_EXISTS (err u101))
(define-constant ERR_NOT_FOUND (err u102))
(define-constant ERR_SELF_REVIEW (err u103))

;; Data structures
(define-map reviews
  { provider-id: principal, review-id: uint }
  {
    reviewer: principal,
    review-date: uint,
    category: (string-utf8 50),
    rating: uint,
    comments: (string-utf8 500),
    verified: bool,
    verifier: (optional principal)
  }
)

;; Track review count per provider
(define-map provider-review-count
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

;; Get next review ID for a provider
(define-private (get-next-review-id (provider-id principal))
  (let ((current-count (default-to { count: u0 } (map-get? provider-review-count { provider-id: provider-id }))))
    (begin
      (map-set provider-review-count
              { provider-id: provider-id }
              { count: (+ u1 (get count current-count)) })
      (get count current-count)
    )
  )
)

;; Submit peer review
(define-public (submit-review
                (provider-id principal)
                (category (string-utf8 50))
                (rating uint)
                (comments (string-utf8 500)))
  (let ((next-id (get-next-review-id provider-id)))
    (begin
      (asserts! (not (is-eq tx-sender provider-id)) ERR_SELF_REVIEW)
      (asserts! (<= rating u5) (err u104)) ;; Rating must be between 0 and 5
      (ok (map-set reviews
                  { provider-id: provider-id, review-id: next-id }
                  {
                    reviewer: tx-sender,
                    review-date: block-height,
                    category: category,
                    rating: rating,
                    comments: comments,
                    verified: false,
                    verifier: none
                  }))
    )
  )
)

;; Verify review
(define-public (verify-review (provider-id principal) (review-id uint))
  (let ((review (map-get? reviews { provider-id: provider-id, review-id: review-id })))
    (begin
      (asserts! (or (is-contract-owner) (is-authorized-verifier)) ERR_UNAUTHORIZED)
      (asserts! (is-some review) ERR_NOT_FOUND)
      (ok (map-set reviews
                  { provider-id: provider-id, review-id: review-id }
                  (merge (unwrap-panic review)
                        {
                          verified: true,
                          verifier: (some tx-sender)
                        })))
    )
  )
)

;; Get review
(define-read-only (get-review (provider-id principal) (review-id uint))
  (map-get? reviews { provider-id: provider-id, review-id: review-id })
)

;; Get review count for a provider
(define-read-only (get-review-count (provider-id principal))
  (default-to { count: u0 } (map-get? provider-review-count { provider-id: provider-id }))
)

;; Calculate average rating for a provider
(define-read-only (get-average-rating (provider-id principal))
  (let ((review-count (get count (get-review-count provider-id))))
    (if (is-eq review-count u0)
      u0
      ;; Note: In a real implementation, we would need to iterate through all reviews
      ;; and calculate the average. This is simplified for demonstration purposes.
      ;; A more complete implementation would require off-chain calculation or
      ;; maintaining a running average in a separate map.
      u0
    )
  )
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
