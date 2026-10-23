package app

import (
	"context"
	"errors"

	"github.com/david88558855/arctic-fox-disk/server/internal/platform/config"
	"github.com/david88558855/arctic-fox-disk/server/internal/platform/database"
	"github.com/david88558855/arctic-fox-disk/server/internal/platform/logger"
)

var (
	PROCESS     = "arctic-fox-disk"
	VERSION     = "dev"
	DESCRIPTION = "Multi-protocol cloud file upload and management with serverless."
)

type Context struct {
	context.Context
	DB     *database.DB
	Logger *logger.Logger
	Config *config.Config
}

func NewContext(cfg *config.Config, log *logger.Logger, db *database.DB) (*Context, error) {
	if cfg == nil {
		return nil, errors.New("config is required")
	}
	if log == nil {
		return nil, errors.New("logger is required")
	}
	if db == nil {
		return nil, errors.New("database is required")
	}
	return &Context{Context: context.Background(), Config: cfg, Logger: log, DB: db}, nil
}
