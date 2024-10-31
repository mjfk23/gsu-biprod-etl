<?php

declare(strict_types=1);

namespace Gsu\Biprod\Command;

use Symfony\Component\Console\Attribute\AsCommand;
use Symfony\Component\Console\Input\InputInterface;

#[AsCommand('biprod:skill')]
final class Skill extends Biprod
{
    /** @inheritdoc */
    protected function getShellArgs(InputInterface $input): array
    {
        return [
            $this->sqlplus('SKILL_OWNER.sql'),
            $this->sqlplus('SKILL_LEVEL.sql'),
            $this->sqlplus('SKILL_DETAIL.sql'),
            $this->sqlplus('SKILL_ASSESSMENT.sql'),
        ];
    }
}
