#include <stdint.h>

uint32_t _http_resp_new(uint32_t *p) __attribute__((
  __import_module__("fastly_http_resp"),
  __import_name__(("new"))
));

uint32_t http_resp_new(uint32_t *p) {
  return _http_resp_new(p);
}

uint32_t _http_resp_header_insert(uint32_t handle, uint8_t *name, uint32_t name_len, uint8_t *value, uint32_t value_len) __attribute__((
  __import_module__("fastly_http_resp"),
  __import_name__(("header_insert"))
));

uint32_t http_resp_header_insert(uint32_t handle, uint8_t *name, uint32_t name_len, uint8_t *value, uint32_t value_len) {
  return _http_resp_header_insert(handle, name, name_len, value, value_len);
}

uint32_t _http_resp_send_downstream(uint32_t resp_handle, uint32_t body_handle, uint32_t streaming) __attribute__((
  __import_module__("fastly_http_resp"),
  __import_name__(("send_downstream"))
));

uint32_t http_resp_send_downstream(uint32_t resp_handle, uint32_t body_handle, uint32_t streaming) {
  return _http_resp_send_downstream(resp_handle, body_handle, streaming);
}

uint32_t _http_resp_close(uint32_t p) __attribute__((
  __import_module__("fastly_http_resp"),
  __import_name__(("close"))
));

uint32_t http_resp_close(uint32_t p) {
  return _http_resp_close(p);
}

uint32_t _http_body_new(uint32_t *p) __attribute__((
  __import_module__("fastly_http_body"),
  __import_name__(("new"))
));

uint32_t http_body_new(uint32_t *p) {
  return _http_body_new(p);
}

uint32_t _http_body_write(uint32_t p, uint8_t *buf, uint32_t buf_len, uint32_t end, uint32_t *nwritten) __attribute__((
  __import_module__("fastly_http_body"),
  __import_name__(("write"))
));

uint32_t http_body_write(uint32_t p, uint8_t *buf, uint32_t buf_len, uint32_t end, uint32_t *nwritten) {
  return _http_body_write(p, buf, buf_len, end, nwritten);
}

