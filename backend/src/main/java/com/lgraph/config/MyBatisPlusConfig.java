package com.lgraph.config;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.context.annotation.Configuration;

@Configuration
@MapperScan("com.lgraph.mapper")
public class MyBatisPlusConfig {
}
