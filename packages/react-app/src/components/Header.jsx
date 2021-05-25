import React from "react";
import { PageHeader } from "antd";

export default function Header() {
  return (
    <a href="/" /*target="_blank" rel="noopener noreferrer"*/>
      <PageHeader
        title="Staker App"
        subTitle=""
        style={{ cursor: "pointer" }}
      />
    </a>
  );
}
