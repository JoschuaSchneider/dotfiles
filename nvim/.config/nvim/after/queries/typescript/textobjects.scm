;; inherits: typescript
;; extends

(pair
  key: (property_identifier) @key
  value: (_) @value) @keyvalue.inner

(pair
  key: (property_identifier) @key
  value: (_) @value
  (","?) @tc) @keyvalue.outer
