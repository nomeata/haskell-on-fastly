#include <stdint.h>

// http_req

uint32_t _http_req_body_downstream_get(uint32_t *rh, uint32_t *bh) __attribute__((
  __import_module__("fastly_http_req"),
  __import_name__(("body_downstream_get"))
));

uint32_t http_req_body_downstream_get(uint32_t *rh, uint32_t *by) {
  return _http_req_body_downstream_get(rh, by);
}

uint32_t _http_req_uri_get(uint32_t *rh, uint8_t *buf, uint32_t buf_len, uint32_t *nwritten) __attribute__((
  __import_module__("fastly_http_req"),
  __import_name__(("uri_get"))
));

uint32_t http_req_uri_get(uint32_t *rh, uint8_t *buf, uint32_t buf_len, uint32_t *nwritten) {
  return _http_req_uri_get(rh, buf, buf_len, nwritten);
}

uint32_t _http_req_method_get(uint32_t *rh, uint8_t *buf, uint32_t buf_len, uint32_t *nwritten) __attribute__((
  __import_module__("fastly_http_req"),
  __import_name__(("method_get"))
));

uint32_t http_req_method_get(uint32_t *rh, uint8_t *buf, uint32_t buf_len, uint32_t *nwritten) {
  return _http_req_method_get(rh, buf, buf_len, nwritten);
}


// http_resp

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

// http_body

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

