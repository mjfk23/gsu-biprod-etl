<?php

declare(strict_types=1);

namespace Gsu\Biprod\Command;

use Gadget\Console\Shell\ProcessShellArgs;
use Symfony\Component\Console\Attribute\AsCommand;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;

#[AsCommand('biprod:sso')]
final class SSO extends Biprod
{
    /** @inheritdoc */
    protected function getArgs(
        InputInterface $input,
        OutputInterface $output
    ): array {
        return array_map(fn(array $args) => new ProcessShellArgs($args), [
            $this->shellCommandFactory->console('biprod:create-ssouser-file', ['./var/sqlldr/SSOUSER.dat']),
            $this->shellCommandFactory->sqlldr('./src/ETL/SSOUSER.par', './var/sqlldr/SSOUSER.dat'),
            $this->shellCommandFactory->sqlplus('./src/ETL/SSOUSER.sql')
        ]);
    }
}
