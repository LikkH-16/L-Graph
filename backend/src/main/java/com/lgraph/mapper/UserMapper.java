package com.lgraph.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.lgraph.entity.User;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface UserMapper extends BaseMapper<User> {
}
