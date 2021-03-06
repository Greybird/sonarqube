/*
 * SonarQube, open source software quality management tool.
 * Copyright (C) 2008-2014 SonarSource
 * mailto:contact AT sonarsource DOT com
 *
 * SonarQube is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 3 of the License, or (at your option) any later version.
 *
 * SonarQube is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program; if not, write to the Free Software Foundation,
 * Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */

package org.sonar.server.computation;

import org.junit.Test;
import org.sonar.api.rules.RuleFinder;
import org.sonar.core.component.ComponentDto;
import org.sonar.core.issue.db.IssueStorage;
import org.sonar.core.persistence.MyBatis;
import org.sonar.server.db.DbClient;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.Mockito.mock;

public class ComputeEngineIssueStorageFactoryTest {

  ComputeEngineIssueStorageFactory sut;

  @Test
  public void return_instance_of_compute_engine_issue_storage() throws Exception {
    sut = new ComputeEngineIssueStorageFactory(mock(MyBatis.class), mock(DbClient.class), mock(RuleFinder.class));

    IssueStorage issueStorage = sut.newComputeEngineIssueStorage(mock(ComponentDto.class));

    assertThat(issueStorage).isInstanceOf(ComputeEngineIssueStorage.class);
  }
}
