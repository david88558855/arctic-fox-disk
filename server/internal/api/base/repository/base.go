package repository

import "github.com/david88558855/arctic-fox-disk/server/internal/api/base/types"

type (
	Repository interface {
		SettingRepository
		TaskRepository
	}
	repository struct {
		ctx *types.Context
	}
)

var _ Repository = (*repository)(nil)

func New(ctx *types.Context) Repository {
	return &repository{ctx: ctx}
}
