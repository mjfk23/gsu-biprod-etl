<?php

declare(strict_types=1);

namespace Gsu\Biprod\Command;

use Gadget\Console\Shell\ProcessShellArgs;
use Symfony\Component\Console\Attribute\AsCommand;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;

#[AsCommand('biprod:skill')]
final class Skill extends Biprod
{
    /** @inheritdoc */
    protected function getArgs(
        InputInterface $input,
        OutputInterface $output
    ): array {
        return array_map(fn(array $args) => new ProcessShellArgs($args), [
            $this->shellCommandFactory->sqlplus('./src/ETL/SKILL_OWNER.sql'),
            $this->shellCommandFactory->sqlplus('./src/ETL/SKILL_LEVEL.sql'),
            $this->shellCommandFactory->sqlplus('./src/ETL/SKILL_DETAIL.sql'),
            $this->shellCommandFactory->sqlplus('./src/ETL/SKILL_ASSESSMENT.sql'),
        ]);
    }
}
