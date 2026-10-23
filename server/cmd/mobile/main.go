package server

import (
	"github.com/david88558855/arctic-fox-disk/server/internal/bootstrap"
	_ "golang.org/x/mobile/bind"
)

func Start(cfg string) (string, error) {
	return bootstrap.Start(cfg)
}

func Stop() {
	bootstrap.Stop()
}
