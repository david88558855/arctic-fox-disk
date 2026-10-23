package repository

import "github.com/david88558855/arctic-fox-disk/server/internal/api/file/types"

type (
	Repository interface {
		RepoRepository
	}
	repository struct {
		ctx *types.Context
	}
)

var _ Repository = (*repository)(nil)

func New(ctx *types.Context) Repository {
	return &repository{ctx: ctx}
}
