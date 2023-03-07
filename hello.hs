import System.Environment
import Fastly
import System.Info
import Data.Version

main = do
    (rh, bh, _) <- http_req_body_downstream_get
    (uri, _) <- http_req_uri_get rh
    (method, _) <- http_req_method_get rh

    (handle, _) <- http_resp_new
    http_resp_header_insert handle "Content-Type" "text/plain" >>= print
    (body, _) <- http_body_new
    env <- getEnvironment
    http_body_write body $ unlines
        [ "Hello World, this is Haskell as WebAssembly on Fastly!"
        , "Compiled by " ++ compilerName ++ " " ++ showVersion fullCompilerVersion ++ " running on " ++ os ++ "-" ++ arch
        , show method
        , show uri
        , show env
        ]
    http_resp_send_downstream handle body 0 >>= print
